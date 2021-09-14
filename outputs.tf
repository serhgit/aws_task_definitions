output "apache_php_task_definition_id" {
  value = "${aws_ecs_task_definition.apache_php_rds.id}"
}
