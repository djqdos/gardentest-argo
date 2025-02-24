data "azurerm_key_vault" "existing" {
    name = "rb-test-keyvault-1"
    resource_group_name = "rg-rb-rsg-vault"
}


# Known, singular key
data "azurerm_key_vault_secret" "existing-secret" {
    name = "secret-key"
    key_vault_id = data.azurerm_key_vault.existing.id    
}



resource "azurerm_app_configuration_key" "test" {    
    configuration_store_id = var.app_config_id

    key = data.azurerm_key_vault_secret.existing-secret.name
    type = "vault"
    vault_key_reference = data.azurerm_key_vault_secret.existing-secret.id


    #depends_on = [ azurerm_role_assignment.data_owner ] 
}

