resource "aws_ecs_task_definition" "minecraft_server" {
  family = "minecraft_server"

  requires_compatibilities = ["FARGATE"]
  network_mode       = "awsvpc"
  cpu                = "1024"
  memory             = "2048"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.minecraft_server.id
      transit_encryption = "ENABLED"
    }
  }

  container_definitions = jsonencode({
    "name" : "minecraft-server",
    "image" : "itzg/minecraft-server",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 25565,
        "hostPort" : 25565,
        "protocol" : "tcp"
      }
    ],
    "environment" : [
      {
        "name" : "EULA",
        "value" : "TRUE"
      },
      {
        "name" : "AUTO_STOP",
        "value" : "TRUE"
      },
      {
        "name" : "AUTO_STOP_TIMEOUT_EST",
        "value" : "300"
      },
      {
        "name" : "OVERRIDE_SERVER_PROPERTIES",
        "value" : "true"
      }
    ],
    "mountPoints" : [
      {
        "sourceVolume" : "efs",
        "containerPath" : "/data",
        "readOnly" : false
      }
    ],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "/ecs/minecraft-server",
        "awslogs-region" : aws_region,
        "awslogs-stream-prefix" : "minecraft",
        "awslogs-create-group" : "true"
      }
    }
  })
  
}