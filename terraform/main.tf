data "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "uai" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_name
  resource_group_name = var.resource_group_name
}

data "azurerm_container_app_environment" "example" {
  name                       = var.container_apps_env_name
  resource_group_name        = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_app" "example" {
  name                         = join("-", ["app",var.resource_prefix])
  container_app_environment_id = data.azurerm_container_app_environment.example.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Multiple"

  registry {
    server = data.azurerm_container_registry.acr.login_server
    identity = data.azurerm_user_assigned_identity.uai.id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.uai.id]
  }

  ingress {
    allow_insecure_connections = true
    target_port = var.port
    external_enabled = true

    traffic_weight {
      latest_revision = true
      percentage = 100
    }
  }

  template {
    container {
      name   = join("-", ["container", var.resource_prefix])
      image  = var.image
      cpu    = var.cpu_cores
      memory = var.memory_in_gb
    }
  }
}