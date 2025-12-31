variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-south-2"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "project" {
  type    = string
  default = "platform-engineering-lab"
}

# Best practice: restrict EKS API to *your* IP /32. For quick testing you can keep 0.0.0.0/0.
variable "cluster_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Allowed CIDRs for the public EKS API endpoint."
}
