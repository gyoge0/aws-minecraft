resource "aws_security_group" "minecraft_server_public" {
  name   = "minecraft_server_public"
  vpc_id = aws_vpc.minecraft_server.id
}

// not sure if we need this for fargate
resource "aws_security_group" "minecraft_server_private" {
  name   = "minecraft_server_private"
  vpc_id = aws_vpc.minecraft_server.id
}

resource "aws_vpc_security_group_egress_rule" "minecraft_server_public" {
  security_group_id = aws_security_group.minecraft_server_public.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "minecraft_server_public" {
  security_group_id = aws_security_group.minecraft_server_public.id

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 25565
  to_port     = 25565
}

resource "aws_vpc_security_group_ingress_rule" "minecraft_server_private" {
  security_group_id = aws_security_group.minecraft_server_private.id

  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.minecraft_server_public.id
  from_port                    = 2049
  to_port                      = 2049
}