# ==============================================================================
# VPC
# ==============================================================================
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_vpc"
    }
  )
}


# ==============================================================================
# SUBNET
# ==============================================================================
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "${data.aws_region.current.name}a"

  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_public_subnet"
    }
  )
}


# ==============================================================================
# ROUTE TABLE
# ==============================================================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_public_route_table"
    }
  )
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_igw"
    }
  )
}


# ==============================================================================
# SECURITY GROUPS
# ==============================================================================
resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.main.id
  description = "${var.prefix} - Route table for public subnet"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.enable_ssh_access ? ["ssh"] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_public_sg"
    }
  )
}
