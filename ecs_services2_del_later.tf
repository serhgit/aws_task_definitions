resource "aws_ecs_service" "apache_php_rds2" {
  name            = "${var.environment}_${var.cluster}_apache_php_rds2"
  cluster         = "${var.cluster}"
  task_definition = aws_ecs_task_definition.apache_php_rds2.id
  scheduling_strategy = "DAEMON"

}

