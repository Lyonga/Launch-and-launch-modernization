resource "aws_ecs_task_definition" "amplifier" {
  family                   = var.name
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.main_ecs_tasks.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  container_definitions = jsonencode([
    {
      name        = var.name
      image       = "612958166077.dkr.ecr.us-east-1.amazonaws.com/test:latest"
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
      networkMode = "awsvpc"
      readonlyRootFilesystem = false
      essential   = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/amplifier/awslog"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "us-east-1"
        }
      }

      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
          hostPort      = var.app_port
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
