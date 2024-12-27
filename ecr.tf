resource "aws_ecr_repository" "app3" {
  name                 = "app3"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
