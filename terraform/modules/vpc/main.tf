resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main"
  }
}

# Subnets

resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "pub-sub-1"
  }
}
resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "pub-sub-2"
  }
}


# Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "ex1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "ex2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.public.id
}

