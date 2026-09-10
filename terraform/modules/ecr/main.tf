resource "aws_ecr_repository" "main" {
  name = var.repository_name

  # FIX: IMMUTABLE prevents overwriting tags — important for SHA-tagged CI/CD
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
