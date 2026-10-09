resource "aws_vpc" "taskvpc" {
  cidr_block       = "11.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-learning"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.taskvpc.id
  cidr_block = "11.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub1"
  }
}
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.taskvpc.id
  cidr_block = "11.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "pub2"
  }
}
resource "aws_internet_gateway" "sjit_internet" {
  vpc_id = aws_vpc.taskvpc.id

  tags = {
    Name = "connecting"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.taskvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sjit_internet.id
  }

  tags = {
    Name = "learn route table"
  }
}
resource "aws_route_table_association" "rt_asso1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rt_asso2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt.id
}