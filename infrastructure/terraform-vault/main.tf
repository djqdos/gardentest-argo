
module "resource_group" {
  source = "./modules/resource_group"

  location            = "uksouth"
  resource_group_name = "${var.resource_group_name_prefix}-${var.resource_group_name}"
}


module "keyvault" {
  source = "./modules/keyvault"  

  keyvault_name = "rb-test-keyvault-1"
  keyvault_location = module.resource_group.location
  keyvault_resource_group = module.resource_group.name

  depends_on = [ module.resource_group ]
}
