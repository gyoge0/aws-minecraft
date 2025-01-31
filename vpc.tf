resource "aws_vpc" "minecraft_server" {
  enable_dns_hostnames = true
  cidr_block           = "10.0.0.0/16"
}

resource "aws_subnet" "minecraft_server" {
  vpc_id     = aws_vpc.minecraft_server.id
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "minecraft_server" {
  vpc_id = aws_vpc.minecraft_server.id
}

resource "aws_route_table" "minecraft_server" {
  vpc_id = aws_vpc.minecraft_server.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft_server.id
  }
}

resource "aws_route_table_association" "minecraft" {
  subnet_id      = aws_subnet.minecraft_server.id
  route_table_id = aws_route_table.minecraft_server.id
}
