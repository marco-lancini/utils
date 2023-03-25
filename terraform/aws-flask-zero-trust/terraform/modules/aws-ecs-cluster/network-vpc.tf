# ==============================================================================
# VPC
# ==============================================================================
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name} VPC"
  }
}


# ==============================================================================
# SUBNETS
# ==============================================================================
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "${data.aws_region.current.name}c"

  tags = {
    Name = "${var.cluster_name} Primary Subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.cluster_name} Secondary Subnet"
  }
}


# ==============================================================================
# NETWORKING
# ==============================================================================
#
# ROUTE TABLES
#
resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.vpc.main_route_table_id

  tags = {
    Name = "${var.cluster_name} VPC"
  }
}

#
# Security Group
#
resource "aws_default_security_group" "vpc_default_sg" {
  vpc_id = aws_vpc.vpc.id
}
