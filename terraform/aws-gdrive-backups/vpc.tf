#
# VPC
#
resource "aws_vpc" "backups_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Backups VPC"
  }
}

resource "aws_subnet" "backups_subnet" {
  vpc_id     = aws_vpc.backups_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Backups Subnet"
  }
}

#
# Security Group
#
resource "aws_default_security_group" "backups_vpc_default" {
  provider = aws.ireland
  vpc_id   = aws_vpc.backups_vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#
# Internet Gateway
#
resource "aws_internet_gateway" "backups_gw" {
  vpc_id = aws_vpc.backups_vpc.id

  tags = {
    Name = "Backups VPC"
  }
}

#
# Route Tables
#
resource "aws_default_route_table" "backups_rt" {
  default_route_table_id = aws_vpc.backups_vpc.main_route_table_id

  tags = {
    Name = "Backups VPC"
  }
}

resource "aws_route" "backups_egress" {
  route_table_id         = aws_default_route_table.backups_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.backups_gw.id
}

resource "aws_route_table_association" "backups_egress" {
  subnet_id      = aws_subnet.backups_subnet.id
  route_table_id = aws_default_route_table.backups_rt.id
}
