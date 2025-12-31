resource "aws_ecr_repository" "demo" {
  name         = "${local.name}/demo-app"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}
