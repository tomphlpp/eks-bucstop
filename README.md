EKS Terraform Provisioning with Helm

🚀 This repository provisions an Amazon EKS cluster using Terraform and deploys applications using Helm.
It automates infrastructure provisioning and application deployment for Kubernetes workloads.
📖 Overview

This Terraform configuration:

    Creates an EKS cluster with worker nodes.
    Deploys Helm charts to install Kubernetes applications.
    Supports user-defined Helm values for customization.
    Outputs key cluster details for easy access.

⚙️ Prerequisites

Before using this repo, ensure you have:

    Terraform (>= v1.3) → Install Terraform
    AWS CLI (>= v2.0) → Install AWS CLI
    kubectl (Kubernetes CLI) → Install kubectl
    Helm (>= v3.0) → Install Helm

⚠️ Make sure your AWS credentials are set up:

aws configure

🚀 How to Deploy

1️⃣ Clone this repository:

git clone https://github.com/your-org/eks-terraform.git
cd eks-terraform

2️⃣ Initialize Terraform:

terraform init

3️⃣ Apply Terraform to provision EKS:

terraform apply -auto-approve

✅ This will:

    Create an EKS cluster.
    Deploy the bucstop application using Helm.
    Output details like cluster name, endpoint, and Helm release status.

📤 Outputs

After Terraform finishes, you’ll see:

eks_cluster_name = "my-eks-cluster"
eks_cluster_endpoint = "https://EKS-ENDPOINT.amazonaws.com"
eks_kubectl_command = "aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster"
helm_release_status = "deployed"
helm_release_namespace = "default"
helm_release_version = "./bucstop-chart"
helm_release_last_deployed = "2025-02-15T11:45:00Z"
eks_cloudwatch_log_group_name = "/aws/eks/my-eks-cluster/cluster"

📌 Use the eks_kubectl_command to connect to the cluster:

aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
kubectl get nodes

🎛️ Customizing Helm Deployment

Users can provide their own Helm values instead of the default configuration.
1️⃣ Option 1: Use a Custom values.yaml

Modify values.yaml with your configurations, then apply:

terraform apply -var-file="custom-values.tfvars"

2️⃣ Option 2: Set Helm Values in Terraform

Instead of using values.yaml, define Helm values in Terraform:

variable "bucstop_values" {
  type = map(any)
  default = {
    frontend = {
      enabled     = true
      replicaCount = 2
    }
  }
}

resource "helm_release" "bucstop" {
  name   = "bucstop"
  chart  = "./bucstop-chart"
  values = [yamlencode(var.bucstop_values)]
}

Re-run:

terraform apply

🔌 Connecting to the Cluster

To manually interact with Kubernetes:

aws eks update-kubeconfig --region us-east-1 --name $(terraform output -raw eks_cluster_name)
kubectl get pods -A

To check deployed Helm releases:

helm list

🛠️ Troubleshooting
❌ Helm Release Didn’t Deploy?

Check Helm logs:

helm status bucstop
kubectl get pods -A
kubectl get events --sort-by=.metadata.creationTimestamp

❌ EKS Cluster Not Accessible?

Verify kubeconfig is set up:

aws eks update-kubeconfig --region us-east-1 --name $(terraform output -raw eks_cluster_name)
kubectl get nodes

💥 Destroying Everything

To remove the entire infrastructure:

terraform destroy -auto-approve

🚨 Warning: This will delete:

    The EKS cluster
    All worker nodes
    The deployed Helm charts

📜 Summary

✅ This repo automates provisioning an AWS EKS cluster with Terraform
✅ Helm is used to deploy the bucstop application automatically
✅ Users can customize Helm values via values.yaml or Terraform variables
✅ Outputs help users easily connect to the cluster

🚀 Now you have a fully automated EKS + Helm setup! 🚀
