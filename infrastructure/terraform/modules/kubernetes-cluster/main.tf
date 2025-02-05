resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "test-aks"
  location            = var.cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "rb"
  kubernetes_version  = "1.29.0"

  default_node_pool {
    name            = "default" # should this be hardcoded?
    node_count      = 1
    vm_size         = "Standard_A2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.service_principal_id
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "rb-test"
  }

}
