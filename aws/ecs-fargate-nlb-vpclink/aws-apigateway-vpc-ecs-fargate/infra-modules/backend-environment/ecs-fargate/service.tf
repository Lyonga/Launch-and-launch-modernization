resource "aws_ecs_service" "amplifier" {
  name            = "${var.name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.amplifier.family
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${var.aws_security_group_ecs_tasks_id}"]
    subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_tg.arn
    container_name   = var.name
    container_port   = var.app_port
  }

  depends_on = [
    aws_ecs_task_definition.amplifier,
  ]

  service_registries {
    registry_arn   = aws_service_discovery_service.amplifier.arn
    container_name = var.ecs_service_name

  }
}