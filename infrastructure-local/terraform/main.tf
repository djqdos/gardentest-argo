
module "resource_group" {
  source = "./modules/resource_group"

  location            = "uksouth"
  resource_group_name = "${var.resource_group_name_prefix}-${var.resource_group_name}"
}


module "kubernetes_cluster" {
  source = "./modules/kubernetes_cluster"

  cluster_location     = module.resource_group.location
  cluster_name         = "test-aks"
  resource_group_name  = module.resource_group.name
  service_principal_id = var.client_id
  password             = var.client_secret
}


module "argocd" {
  source = "./modules/argocd"
  
  depends_on = [module.kubernetes_cluster]
}