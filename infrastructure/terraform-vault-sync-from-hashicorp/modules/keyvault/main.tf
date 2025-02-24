data "azurerm_client_config" "current" { }


resource "azurerm_key_vault" "keyvault" {
    name = var.keyvault_name
    resource_group_name = var.keyvault_resource_group
    enabled_for_disk_encryption = true
    tenant_id = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days = 7
    public_network_access_enabled = true
    sku_name = "standard"
    location = var.keyvault_location

    enable_rbac_authorization = true

    #network_acls {
    #  bypass = "AzureServices"
    #  default_action = "Deny"
    #  ip_rules = ["86.140.185.145"]
    #}

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id


        key_permissions = [
            "Create",
            "Get",
            "List"
        ]

        secret_permissions = [
            "Set",
            "Get",
            "Delete",
            "Purge",
            "Recover"
        ]
    }

    #depends_on = [ azurerm_role_assignment.keyvault_roles, azurerm_role_assignment.rb_keyvault_role ]
}

resource "azurerm_role_assignment" "keyvault_roles" {
    scope = azurerm_key_vault.keyvault.id
    role_definition_name = "Key Vault Administrator"
    principal_id = data.azurerm_client_config.current.object_id
}


# DO NOT CHECK THIS IN.. give r.bartlett@openenergymarket.com user access to key vault
# mainly, so I could check the secret was added from portal
resource "azurerm_role_assignment" "rb_keyvault_role" {
    scope = azurerm_key_vault.keyvault.id
    role_definition_name = "Key Vault Administrator"
    principal_id = "847c0dbd-6dc7-4238-8c1d-d1b0a6966cc3"
}


resource "azurerm_key_vault_secret" "secrets" {
    name = "secret-key"
    value = "supersecretvalue"
    key_vault_id = azurerm_key_vault.keyvault.id

    depends_on = [ azurerm_role_assignment.keyvault_roles, azurerm_role_assignment.rb_keyvault_role ]
}

resource "azurerm_key_vault_secret" "secrets-2" {
    name = "secret-key-2"
    value = "supersecretvalue2"
    key_vault_id = azurerm_key_vault.keyvault.id

    depends_on = [ azurerm_role_assignment.keyvault_roles, azurerm_role_assignment.rb_keyvault_role ]
}

resource "azurerm_key_vault_secret" "secrets-3" {
    name = "secret-key-3"
    value = "supersecretvalue-3"
    key_vault_id = azurerm_key_vault.keyvault.id

    depends_on = [ azurerm_role_assignment.keyvault_roles, azurerm_role_assignment.rb_keyvault_role ]
}