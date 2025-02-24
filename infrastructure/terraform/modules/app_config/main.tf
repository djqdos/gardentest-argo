locals {
    config_mapping = {
        testkey = "some value"
        testKey2 = "another value"
        testKey3 = "3rd value"
    }
}

data "azurerm_client_config" "current" {}


# Create the Application Configuration
resource "azurerm_app_configuration" "app_config" {
    name = "${var.resource_group_name}-my-app-config"
    resource_group_name = var.resource_group_name
    location = var.location     

    sku = "standard"
}


# Apply the role of "App Configuration Data Owner" to the service principal
resource "azurerm_role_assignment" "data_owner" {
    scope = azurerm_app_configuration.app_config.id
    role_definition_name =  "App Configuration Data Owner"
    principal_id = data.azurerm_client_config.current.object_id

    depends_on = [ azurerm_app_configuration.app_config ]
}


# Loop through the 'config_mapping' elements, and create an entry into App Config for each one
resource "azurerm_app_configuration_key" "test" {
    for_each = local.config_mapping

    configuration_store_id = azurerm_app_configuration.app_config.id

    key = each.key
    value = each.value   

    depends_on = [ azurerm_role_assignment.data_owner ] 
}


module "add_key" {
    source = "../app_config_key"
    key = "KeyFromModule"
    value = "KeyFromModuleValue"
    app_config_id = azurerm_app_configuration.app_config.id

    depends_on = [ azurerm_role_assignment.data_owner ] 
}


# dynamically add in a Feature Flag into App Configuration
resource "azurerm_app_configuration_feature" "testfeature" {
  configuration_store_id = azurerm_app_configuration.app_config.id
  name = "testfeature"
  enabled = true
  description = "test feature flag"
  label = "testlabel"

  depends_on = [ azurerm_role_assignment.data_owner ]
}
