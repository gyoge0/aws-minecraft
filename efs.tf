resource "aws_efs_file_system" "minecraft_server" {
  creation_token = "minecraft_server"
}

resource "aws_efs_backup_policy" "minecraft_server" {
  file_system_id = aws_efs_file_system.minecraft_server.id
  backup_policy {
    status = "DISABLED"
  }
}

resource "aws_efs_mount_target" "minecraft_server" {
  file_system_id = aws_efs_file_system.minecraft_server.id
  subnet_id      = aws_subnet.minecraft_server.id
  security_groups = [
    aws_security_group.minecraft_server_private.id
  ]
}
