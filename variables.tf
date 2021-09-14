variable "environment" {
  description = "The name of the environment"
}
variable "aws_region"{
  description = "AWS region"
}
variable "aws_profile" {
  description = "AWS profile for aws cli"
}
variable "cluster" {
  description = "The ECS cluster name"
}

variable "web_lb_tg_arn" {
  description = "ARN of LB target group which we attach to the service"
}
variable "secret_manager_arn" {
  description = "ARN of the secret manager where we store secret credentials"
}
variable "image_tag" {
  description = "Version of our container image"
}
