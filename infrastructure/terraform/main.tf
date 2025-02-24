
module "resource_group" {
  source = "./modules/resource_group"

  location            = "uksouth"
  resource_group_name = "${var.resource_group_name_prefix}-${var.resource_group_name}"
}


module "app_config" {
  source = "./modules/app_config"

  location = "uksouth"
  resource_group_name = "${var.resource_group_name_prefix}-${var.resource_group_name}"
  client_id = var.client_id

  depends_on = [module.resource_group]

}

# add app-config reference to a known-name / singular key vault item
# module "populate_app_config_from_kv" {
#   source = "./modules/populate-app-config"

#   app_config_id = module.app_config.app_config_id

#   depends_on = [ module.app_config ]
# }


# Add list of secrets from an existing key-vault
module "populate_app_config_from_kv_loop" {
  source = "./modules/populate-app-config-all"

  app_config_id = module.app_config.app_config_id

  depends_on = [ module.app_config ]
}


#This currently doesn't work - ephemeral resources can't be used in normal resources yet
# module "populate_app_config_from_kv_loop_ephemeral" {
#   source = "./modules/populate-app-config-all-ephemeral"

#   app_config_id = module.app_config.app_config_id

#   depends_on = [ module.app_config ]
# }




# module "kubernetes_cluster" {
#   source = "./modules/kubernetes_cluster"

#   cluster_location     = module.resource_group.location
#   cluster_name         = "test-aks"
#   resource_group_name  = module.resource_group.name
#   service_principal_id = var.client_id
#   password             = var.client_secret

#   depends_on = [ module.resource_group ]
# }


# module "consul" {
#   source = "./modules/consul"

#   depends_on = [ module.kubernetes_cluster ]
# }

# module "argocd" {
#   source = "./modules/argocd"
  
#   depends_on = [module.kubernetes_cluster]
# }

# resource "kubernetes_manifest" "application_app_of_apps" {
#   manifest = {
#     "apiVersion" = "argoproj.io/v1alpha1"
#     "kind" = "Application"
#     "metadata" = {
#       "name" = "app-of-apps"
#       "namespace": "argocd"
#     }
#     "spec" = {
#       "destination" = {
#         "name" = "in-cluster"
#         "namespace" = "argocd"
#       }
#       "project" = "default"
#       "source" = {
#         "path" = "infrastructure/apps"
#         "repoURL" = "https://github.com/djqdos/gardentest-argo.git"
#         "targetRevision" = "HEAD"
#       }
#     }
#   }

#   depends_on = [module.argocd]
# }