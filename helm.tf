provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "helm_release" "bucstop" {
  name      = "bucstop"
  namespace = "default"
  chart     = "./bucstop-chart/bucstop" 

  create_namespace = true

  values = [
    file("values.yaml") 
  ]

  set {
    name  = "gateway.enabled"
    value = "true"
  }
}

