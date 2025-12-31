# Milestone 1 — Terraform creates EKS + Argo CD

## Outcome
- **Infrastructure:** VPC + EKS + 1 EKS Managed Node Group (min=1, desired=1, max=2).
- **Management Plane:** Argo CD installed automatically via Terraform Helm Provider.
- **State:** Terraform remote state stored in S3 with native locking (`use_lockfile = true`).

## Prerequisites
- AWS CLI authenticated with Administrator permissions: `aws sts get-caller-identity`
- Terraform (v1.5+) installed.
- `kubectl` installed.

## Quick Start

### 1. Bootstrap State Bucket (One-time)
If you haven't created your remote state bucket yet, run this locally.

**Note:** You can use the `scripts/state-bootstrap.sh` script if available, or run:

```bash
export AWS_REGION="eu-south-2"
export TFSTATE_BUCKET="platform-engineering-lab-tfstate-$(date +%Y%m%d)-$RANDOM"

# Create Bucket
aws s3api create-bucket \
  --bucket "$TFSTATE_BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

# Enable Versioning (Recommended for State)
aws s3api put-bucket-versioning \
  --bucket "$TFSTATE_BUCKET" \
  --versioning-configuration Status=Enabled

echo "Your State Bucket: $TFSTATE_BUCKET"
```
### 2. Configure Backend
Create `infra/backend.hcl`. Do not commit this file if it contains sensitive hardcoded values (though bucket names are generally non-sensitive).
```h
bucket       = "REPLACE_WITH_YOUR_BUCKET_NAME"
key          = "eks/terraform.tfstate"
region       = "eu-south-2"
encrypt      = true
use_lockfile = true
```
### 3. Deploy Infrastructure
This step provisions the network, the cluster, the nodes, and installs Argo CD.
```bash
cd infra

# Initialize with backend config
terraform init -backend-config=backend.hcl

# Format and Validate
terraform fmt -recursive
terraform validate

# Plan and Apply
terraform plan -out=tfplan
terraform apply tfplan
```
Note: This process typically takes 15–20 minutes.
### 4. Verfication
Once Terraform completes, configure your local access and verify components.
```bash
# 1. Update local kubeconfig
aws eks update-kubeconfig --region eu-south-2 --name platform-engineering-lab

# 2. Verify Worker Nodes
kubectl get nodes -o wide
# Expected: 1 Ready node.

# 3. Verify Argo CD Installation
kubectl get pods -n argocd
# Expected: All pods (server, repo-server, application-controller, etc.) showing "Running".
```
### 5. Trobleshooting

- Helm Timeout: If Argo CD fails to install, check if the Node Group is actually `Ready`.
  Terraform usually handles the dependency, but sometimes the VPC CNI takes a moment to initialize.

- Locking Error: If you see a lock ID, someone else (or a hung process) holds the state. Use `terraform force-unlock <LOCK_ID>`.

### 6. Teardown (Important)
To avoid unnecessary AWS costs, destroy the lab when finished.

```bash
cd infra
terraform destroy
```