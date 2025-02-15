## Warning: Before this can be used collaboratively, you must configure terraform remote state storage. (Can be an s3 bucket)

# EKS Terraform Provisioning with Helm

This repository provisions an Amazon EKS cluster using Terraform and deploys applications using Helm.
It automates infrastructure provisioning and application deployment for Kubernetes workloads.
## Overview

This Terraform configuration:

    1. Creates an EKS cluster with worker nodes.
    2. Deploys Helm charts to install Kubernetes applications.
    3. Supports user-defined Helm values for customization.
    4. Outputs key cluster details for easy access.

## Prerequisites

Before using this repo, ensure you have:
```
    Terraform (>= v1.3) → Install Terraform
    AWS CLI (>= v2.0) → Install AWS CLI
    kubectl (Kubernetes CLI) → Install kubectl
    Helm (>= v3.0) → Install Helm
```
Make sure your AWS credentials are set up:
```
aws configure
```
## How to Deploy

Clone this repository:
```
git clone https://github.com/your-org/eks-terraform.git
cd eks-terraform
```
## Initialize Terraform:
```
terraform init
```
## Apply Terraform to provision EKS:
```
terraform apply -auto-approve
```
This will:

    1. Create an EKS cluster.
    2. Deploy the bucstop application using Helm.
    3. Output details like cluster name, endpoint, and Helm release status.

## Outputs

After Terraform finishes, you’ll see:
```
eks_cluster_name = "my-eks-cluster"
eks_cluster_endpoint = "https://EKS-ENDPOINT.amazonaws.com"
eks_kubectl_command = "aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster"
helm_release_status = "deployed"
helm_release_namespace = "default"
helm_release_version = "./bucstop-chart"
helm_release_last_deployed = "2025-02-15T11:45:00Z"
eks_cloudwatch_log_group_name = "/aws/eks/my-eks-cluster/cluster"
```
## Use the eks_kubectl_command to connect to the cluster:
```
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
kubectl get nodes
```
## Customizing Helm Deployment

Users can provide their own Helm values instead of the default configuration.
To deploy new container images for bucstop services, simple go into the values.yaml in the root of this repository and include the image name at the corresponding key.

## Connecting to the Cluster

To manually interact with Kubernetes:
```
aws eks update-kubeconfig --region us-east-1 --name $(terraform output -raw eks_cluster_name)
kubectl get pods -A
```
### To check deployed Helm releases:
```
helm list
```

## To remove the entire infrastructure:
```
terraform destroy -auto-approve
```
Warning: This will delete:

    The EKS cluster
    All worker nodes
    The deployed Helm charts

You may want to use terraform destroy pretty often to save money if this is for a school project.

