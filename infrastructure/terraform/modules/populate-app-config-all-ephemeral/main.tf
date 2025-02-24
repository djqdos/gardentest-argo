# Get reference to existing key-vault
data "azurerm_key_vault" "existing" {
    name = "rb-test-keyvault-1"
    resource_group_name = "rg-rb-rsg-vault"
}

# get list of secrets from the keyvault
data "azurerm_key_vault_secrets" "secrets" {
    key_vault_id = data.azurerm_key_vault.existing.id
}

# get each secret
ephemeral "azurerm_key_vault_secret" "loop" {
    for_each = toset(data.azurerm_key_vault_secrets.secrets.names)

    name = each.key
    key_vault_id = data.azurerm_key_vault_secrets.secrets.id    
}


locals {
    items = ephemeral.azurerm_key_vault_secret.loop
}


# loop through the secrets, and apply them to the app-config
resource "azurerm_app_configuration_key" "test" {    
    configuration_store_id = var.app_config_id

    for_each = local.items

    key = local.items[each.key].name
    type = "vault"
    vault_key_reference = local.items[each.key].versionless_id    
}

