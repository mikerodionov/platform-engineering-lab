resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.52.0" # Good practice to pin chart versions

  # Wait for the Application Controller to be ready
  wait = true

  # Set values to keep costs low and configuration simple for the lab
  values = [
    <<EOF
server:
  service:
    type: ClusterIP  # We will use port-forwarding, no LoadBalancer cost
  extraArgs:
    - --insecure     # Optional: helps with some TLS issues in labs
configs:
  params:
    server.insecure: true
EOF
  ]

  # CRITICAL: Do not try to install until nodes are ready
  depends_on = [module.eks]
}
