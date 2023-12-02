data "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "uai" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  image_registry_credential {
    server = data.azurerm_container_registry.acr.login_server
    user_assigned_identity_id = data.azurerm_user_assigned_identity.uai.id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.uai.id]
  }

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}