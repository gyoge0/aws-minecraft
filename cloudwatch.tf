resource "aws_cloudwatch_log_group" "minecraft_server" {
  name = "/minecraft_server"
  retention_in_days = 7
  log_group_class = "STANDARD"
}