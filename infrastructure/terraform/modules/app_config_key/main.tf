
resource "azurerm_app_configuration_key" "test" {    
    configuration_store_id = var.app_config_id

    key = var.key
    value = var.value

    #depends_on = [ azurerm_role_assignment.data_owner ] 
}

# dynamically add in a Feature Flag into App Configuration
# resource "azurerm_app_configuration_feature" "testfeature" {
#   configuration_store_id = azurerm_app_configuration.app_config.id
#   name = "testfeature"
#   enabled = true
#   description = "test feature flag"
#   label = "testlabel"
# }




