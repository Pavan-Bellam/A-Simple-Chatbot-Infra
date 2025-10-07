#vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "chatbot-main-vpc" }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "chatbot-main-igw" }
}

#public subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[index(var.public_subnet_cidrs, each.value)]
  map_public_ip_on_launch = true
  tags                    = { Name = "chatbot-main-public-subnet-${index(var.public_subnet_cidrs, each.value)}" }
}

#private subnets
resource "aws_subnet" "private" {
  for_each                = toset(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[index(var.private_subnet_cidrs, each.value)]
  map_public_ip_on_launch = false
  tags                    = { Name = "chatbot-main-private-subnet-${index(var.private_subnet_cidrs, each.value)}" }
}

#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "chatbot-main-public-route-table" }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

#nat gateway

#elastic ip
resource "aws_eip" "nat_eip" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = { Name = "chatbot-main-nat-gateway-0" }
}

#private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
    }
  }
  tags = { Name = "chatbot-main-private-route-table" }
}

#private route table association
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}