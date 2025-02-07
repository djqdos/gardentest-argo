
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

  depends_on=[module.resource_group]
}


module "argocd" {
  source = "./modules/argocd"
  
  depends_on = [module.kubernetes_cluster]
}

resource "kubernetes_manifest" "application_app_of_apps" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "app-of-apps"
      "namespace": "argocd"
    }
    "spec" = {
      "destination" = {
        "name" = "in-cluster"
        "namespace" = "argocd"
      }
      "project" = "default"
      "source" = {
        "path" = "infrastructure/apps"
        "repoURL" = "https://github.com/djqdos/gardentest-argo.git"
        "targetRevision" = "HEAD"
      }
    }
  }

  depends_on = [module.argocd]
}