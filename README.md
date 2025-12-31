# Platform Engineering Lab (EKS + Terraform + GitOps)

This repo is a minimal, cost-conscious lab project designed to build confidence in **production-ish Kubernetes** and **GitOps**, aligned with a Senior/Lead Platform Engineer job scope.

It demonstrates a "Platform as a Product" approach: automating the creation of the cluster, bootstrapping the management plane (Argo CD), and providing a standardized contract for application deployment.

## Goals
- Provision a clean **EKS** cluster with **Terraform** (Remote state, locking, Helm provider).
- Bootstrap **Argo CD** automatically via Infrastructure-as-Code.
- Manage cluster workloads via **GitOps** (App-of-Apps pattern).
- Implement **CI** pipelines with **GitHub Actions**.

---

## Repository Structure

| Folder     | Purpose                                                                          |
|:-----------|:---------------------------------------------------------------------------------|
| `infra/`   | **Terraform code**. Defines VPC, EKS, Node Groups, and installs Argo CD.         |
| `gitops/`  | **Argo CD Manifests**. Defines the "desired state" of the cluster (App-of-Apps). |
| `apps/`    | **Source Code**. The demo applications (Dockerfile, source code) built by CI.    |
| `docs/`    | **Documentation**. Detailed guides for each milestone.                           |
| `.github/` | **CI/CD**. GitHub Actions workflows for Terraform linting and App builds.        |

---

## Roadmap

### [Milestone 1: Infrastructure & Bootstrap](docs/milestone-1.md)
*Status: Complete*
- Create VPC, EKS, and Managed Node Groups via Terraform.
- **Bootstrap Argo CD** using the Terraform Helm Provider.
- **Deliverable:** `kubectl get nodes` and `kubectl get pods -n argocd` show a healthy cluster.

### [Milestone 2: GitOps Configuration](docs/milestone-2.md)
*Status: In Progress*
- Configure Argo CD access (port-forwarding).
- Create the **"Root App"** (App-of-Apps pattern) to watch the `gitops/apps` folder.
- **Deliverable:** Argo CD UI shows the root application synced and healthy.

### Milestone 3: Demo App Deployment
*Status: Planned*
- Define a demo application in `gitops/apps`.
- Demonstrate GitOps lifecycle (Sync, Drift Detection, Self-Heal).
- **Deliverable:** A "Hello World" app is accessible in the cluster.

### Milestone 4: CI Pipelines
*Status: Planned*
- Terraform CI: Format, Validate, and Plan on Pull Requests.
- App CI: Build container, push to ECR, and update the image tag in `gitops/`.
- **Deliverable:** A git commit to `apps/` triggers a build and a deployment update.

### Milestone 5: Self-Hosted Runners (Advanced)
*Status: Planned*
- Deploy Actions Runner Controller (ARC) to the cluster.
- Run CI jobs on Kubernetes pods instead of GitHub-hosted runners.

---

## Prerequisites
1.  **AWS CLI** configured (`aws sts get-caller-identity`).
2.  **Terraform** (v1.5+).
3.  **kubectl** installed.
4.  **GitHub Token** (if using private repositories).

## Cost Awareness
This lab uses real AWS resources. To avoid unexpected bills:
- **EKS Control Plane:** ~$0.10/hour (approx $72/month if left running).
- **EC2 Nodes:** t3.medium/small (Spot or On-Demand).
- **Load Balancers:** Intentionally avoided in early milestones (using Port Forwarding).

**ALWAYS run `terraform destroy` when you are finished with a session.**