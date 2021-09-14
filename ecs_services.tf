resource "aws_ecs_service" "apache_php_rds" {
  name            = "${var.environment}_${var.cluster}_apache_php_rds"
  cluster         = "${var.cluster}"
  task_definition = aws_ecs_task_definition.apache_php_rds.id
  scheduling_strategy = "DAEMON"

  load_balancer {
    target_group_arn = "${var.web_lb_tg_arn}"
    container_name   = "apache_php_rds"
    container_port   = 80
  }
}

