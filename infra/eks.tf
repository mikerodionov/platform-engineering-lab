module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets # Nodes in public subnets (Cost saving: No NAT GW)

  # --- Access ---
  cluster_endpoint_public_access = true
  # Only allow your IP if possible, otherwise open to world (0.0.0.0/0) for lab
  # cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] 

  # --- Admin Permissions ---
  # Grants the user running Terraform admin rights (critical for labs)
  enable_cluster_creator_admin_permissions = true

  # --- Nodes ---
  eks_managed_node_groups = {
    default = {
      name = "${local.name}-mng"

      # IAM Role Name Fix (prevents "name too long" errors)
      iam_role_use_name_prefix = false
      iam_role_name            = "pe-lab-mng-role"

      instance_types = ["t3.medium"] # t3.small is often too small for EKS system pods + Argo
      capacity_type  = "SPOT"        # Save money

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = local.tags
}
