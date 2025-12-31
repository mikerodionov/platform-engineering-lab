output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.region
}

output "ecr_repo_url" {
  value = aws_ecr_repository.demo.repository_url
}
