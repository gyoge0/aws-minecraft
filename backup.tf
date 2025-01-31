# set up a bunch of iam roles for backups
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role_policy_attachment" "minecraft_server_backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.minecraft_server_backup.name
}

resource "aws_iam_role" "minecraft_server_backup" {
  name               = "minecraft_server_backup"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# actual backup resources
resource "aws_backup_vault" "minecraft_server_backup" {
  name = "minecraft_server_backup"
}

resource "aws_backup_plan" "minecraft_server_backup" {
  name = "minecraft_server_backup"
  rule {
    rule_name         = "minecraft_server_backup"
    target_vault_name = aws_backup_vault.minecraft_server_backup.name
    # 11 am UTC, 6 am EST
    schedule = "cron(0 11 * * ? *)"
    lifecycle {
      delete_after = 5
    }
  }
}

resource "aws_backup_selection" "minecraft_server_backup" {
  iam_role_arn = aws_iam_role.minecraft_server_backup.arn
  name         = "minecraft_server_backup"
  plan_id      = aws_backup_plan.minecraft_server_backup.id

  resources = [
    aws_efs_file_system.minecraft_server.arn
  ]
}
