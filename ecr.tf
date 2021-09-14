resource "aws_ecr_repository" "scratch_hello" {
  name                 = "scratch_hello"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "scratch_hello"
  }
}

resource "aws_ecr_repository" "apache_php_rds" {
  name                 = "apache_php_rds"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "apache_php_rds"
  }
}
