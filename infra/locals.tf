locals {
  name   = "platform-engineering-lab"
  region = var.region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Project    = local.name
    Repository = "platform-engineering-lab"
    ManagedBy  = "Terraform"
  }
}
