resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "eks_gateway" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_subnet" "public_subnet" {
  availability_zone = "ap-south-1a"
  vpc_id           = aws_vpc.eks_vpc.id
  cidr_block       = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  availability_zone = "ap-south-1b"
  vpc_id           = aws_vpc.eks_vpc.id
  cidr_block       = "10.0.2.0/24"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "public_route" {
  route_table_id  = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.eks_gateway.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
