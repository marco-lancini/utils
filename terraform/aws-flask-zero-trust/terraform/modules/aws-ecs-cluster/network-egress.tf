# ==============================================================================
# Internet Gateway
# ==============================================================================
#
# IGW
#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name} IGW"
  }
}

#
# Add egress route to route table
#
resource "aws_route" "egress" {
  route_table_id         = aws_default_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "egress" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_default_route_table.rt.id
}
