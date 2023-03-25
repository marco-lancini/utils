locals {
  endpoints_gateway   = toset(var.endpoints_gateway_list)
  endpoints_interface = toset(var.endpoints_interface_list)
}

# ==============================================================================
# Gateway Endpoints (S3, DynamoDB)
# ==============================================================================
#
# Endpoints
#
resource "aws_vpc_endpoint" "endpoints_gw" {
  for_each = local.endpoints_gateway

  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "${var.cluster_name} Gateway VPC Endpoint: ${each.key}"
  }
}

#
# Route Table Association
#
resource "aws_vpc_endpoint_route_table_association" "endpoints_gw_association" {
  for_each = aws_vpc_endpoint.endpoints_gw

  vpc_endpoint_id = each.value.id
  route_table_id  = aws_default_route_table.rt.id
}


# ==============================================================================
# Interface Endpoints
#   - 💰 They are charged by the hour!
#   - Supported services: https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
# ==============================================================================
#
# Endpoints
#
resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = local.endpoints_interface

  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_endpoints[0].id
  ]

  subnet_ids = [
    aws_subnet.subnet.id,
    aws_subnet.secondary_subnet.id
  ]

  tags = {
    Name = "${var.cluster_name} Interface VPC Endpoint: ${each.key}"
  }

}

#
# Security Group for Endpoints
#
resource "aws_security_group" "vpc_endpoints" {
  count = length(local.endpoints_interface) > 0 ? 1 : 0

  name        = "${var.cluster_name}-vpc-endpoints"
  description = "Allows instances to reach Interface VPC endpoints"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name} VPC Endpoints"
  }
}

resource "aws_security_group_rule" "vpce_source_https_ingress" {
  count = length(local.endpoints_interface) > 0 ? 1 : 0

  description              = "Accept VPCE traffic"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_default_security_group.vpc_default_sg.id
  security_group_id        = aws_security_group.vpc_endpoints[0].id
}

resource "aws_security_group_rule" "source_vpce_https_egress" {
  count = length(local.endpoints_interface) > 0 ? 1 : 0

  description              = "Allow outbound requests to VPC endpoints"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.vpc_endpoints[0].id
  security_group_id        = aws_default_security_group.vpc_default_sg.id
}
