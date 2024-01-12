resource "aws_ecs_task_definition" "TD" {
  family                   = "Nginx-TD"
  requires_compatibilities = ["FARGATE"]
  #network_mode       =       "awsvpc"
  task_role_arn = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.iam-role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "main-container"
      image     = "612958166077.dkr.ecr.us-east-1.amazonaws.com/test:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      secrets = [
      {
        name      = "USERNAME"
        valueFrom = aws_secretsmanager_secret.username_secret.arn
      },
      {
        name      = "PASSWORD"
        valueFrom = aws_secretsmanager_secret.password_secret.arn
      }
    ]
    }
  ])
}


data "aws_ecs_task_definition" "TD" {
  task_definition = aws_ecs_task_definition.TD.family
}
