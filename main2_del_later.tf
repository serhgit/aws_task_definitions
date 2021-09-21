resource "aws_ecs_task_definition" "apache_php_rds2" {
  family                   = "${var.environment}_${var.cluster}_apache_php_rds2"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::288946686376:role/${var.environment}_${var.cluster}_ecs_tasks_instance_role"
  cpu    = "512"
  memory = "400"
  container_definitions = jsonencode([
    {
      name      = "apache_php_rds"
      image     = "288946686376.dkr.ecr.us-east-1.amazonaws.com/apache_php_rds:${var.environment}-${var.image_tag}"
      cpu       = 200
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 90
        }
      ]
      secrets = [ 
        {
          name             = "db_details"
          valueFrom        = "${var.secret_manager_arn}"
        },
        {
          name             = "bucket_name"
          valueFrom        = "${var.secret_manager_arn}"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.environment}_${var.cluster}_apache_php_rds2"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}
