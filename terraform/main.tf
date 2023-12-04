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

locals {
  clean_revision_label = replace(lower(var.revision_label), ".", "-")
}

resource "azurerm_container_app" "aca" {
  name                         = join("-", [var.resource_prefix, var.app_name])
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
      name   = local.clean_revision_label
      image  = var.image
      cpu    = var.cpu_cores
      memory = var.memory_in_gb
    }
  }
}

resource "azurerm_monitor_action_group" "mag" {
  name                = join("-", [var.resource_prefix, var.app_name, "actiongroup"])
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = var.resource_prefix

  email_receiver {
    name                    = "sendtoadmin"
    email_address           = "adelyn.flowers@gmail.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = join("-", [var.resource_prefix, var.app_name, "metricalert"])
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_container_app.aca.id]
  description         = "Action will be triggered when cpu percent is greater than 80."

  criteria {
    metric_namespace = "Microsoft.App/containerapps"
    metric_name      = "RestartCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 50
  }
  action {
    action_group_id = azurerm_monitor_action_group.mag.id
  }
}