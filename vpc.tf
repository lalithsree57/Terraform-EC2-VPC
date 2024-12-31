resource "aws_vpc" "myvpc" {
  tags = {
    Name = "my-vpc"
  }
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "mysubnet1" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "subnet-1"
  }
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "mysubnet2" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "subnet-2"
  }
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "myigw" {
  tags = {
    Name = "my-igw"
  }
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myrt" {
  tags = {
    Name = "my-rt"
  }
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

resource "aws_route_table_association" "ass1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "ass2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.myrt.id
}







