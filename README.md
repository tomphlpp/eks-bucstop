### Warning: Before this can be used collaboratively, you must configure terraform remote state storage. (Can be an s3 bucket... s3 module included for your convienence in case you don't have on already. Otherwise, just adjust /app/backend.tf with the name of your bucket)
## 🛠️ Cluster Infrastructure

This Terraform configuration creates and manages an **EKS cluster** using the **AWS Terraform modules**. The cluster includes:

- **A fully managed Kubernetes control plane** via `aws_eks_cluster.this[0]`
- **EKS Managed Node Groups** for worker nodes (`aws_eks_node_group.this[0]`)
- **IAM roles and policies** for secure access control (`aws_iam_role.this[0]`, `aws_iam_role_policy_attachment.this[...]`)

### 1️⃣ EKS Cluster Details
- **Control Plane:** Amazon-managed Kubernetes API with auto-scaling and high availability.
- **Worker Nodes:** Managed via **EKS Managed Node Groups** (`module.eks.module.eks_managed_node_group["initial"]`).
- **IAM Authentication:** Uses `data.aws_eks_cluster_auth.cluster` for secure `kubectl` access.
- **Encryption at Rest:** Enabled via **AWS KMS Keys** (`module.eks.module.kms.aws_kms_key.this[0]`).

---

## 🌐 Networking & VPC Architecture

The EKS cluster is deployed within a **dedicated AWS VPC** managed via `module.vpc.aws_vpc.this[0]`, with:

- **Multiple subnets for high availability:**
  - **Public subnets** (`module.vpc.aws_subnet.public[...]`) for externally accessible workloads.
  - **Private subnets** (`module.vpc.aws_subnet.private[...]`) for internal services and worker nodes.
  - **Intra subnets** (`module.vpc.aws_subnet.intra[...]`) for internal communication without internet access.
  
- **Internet Gateway & NAT Gateway:**
  - **Internet Gateway** (`module.vpc.aws_internet_gateway.this[0]`) enables public internet access.
  - **NAT Gateway** (`module.vpc.aws_nat_gateway.this[0]`) allows private resources to access the internet.

- **Route Tables & Associations:**
  - `module.vpc.aws_route_table_association.private[...]` ensures nodes use private routing.
  - `module.vpc.aws_route_table_association.public[...]` routes internet traffic through IGW.

---

## 🔐 Security & IAM

- **EKS Cluster Security Group** (`module.eks.aws_security_group.cluster[0]`):  
  - Restricts API access to authenticated IAM roles.
  
- **Worker Node Security Group** (`module.eks.aws_security_group.node[0]`):  
  - Controls communication between pods and other AWS services.

- **Security Group Rules:**
  - `module.eks.aws_security_group_rule.node["ingress_cluster_443"]`: Controls secure API communication.
  - `module.eks.aws_security_group_rule.node["ingress_nodes_ephemeral"]`: Manages ephemeral ports for pod networking.
  - `module.eks.aws_security_group_rule.node["ingress_cluster_kubelet"]`: Ensures worker nodes can communicate with the API server.

- **IAM Role-Based Access Control (RBAC):**
  - `module.eks.aws_iam_role.this[0]`: IAM role for Kubernetes service accounts.
  - `module.eks.aws_iam_openid_connect_provider.oidc_provider[0]`: Allows Kubernetes workloads to securely authenticate with AWS services via IRSA.

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

