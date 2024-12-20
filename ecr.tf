resource "aws_ecr_repository" "app-2" {
  name                 = "app2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
