variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location for all resources."
}

variable "container_registry_name" {
  type = string
  default = "adelynflowers"
  description = "Name of existing container registry"
}

variable "resource_group_name" {
  type        = string
  default     = "sastakehome"
  description = "Name of the resource group to use"
}

variable "resource_prefix" {
  type = string
  description = "Prefix used for ephemeral resources."
}

variable "image" {
  type        = string
  default = "adelynflowers.azurecr.io/sastakehome:0.0.1-SNAPSHOT"
  description = "Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials."
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 8080
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 0.5
}

variable "memory_in_gb" {
  type        = string
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = "1Gi"
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Never"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "user_assigned_identity_name" {
  type = string
  default = "githubactions-user"
  description = "User assigned identity used to authorize with ACR"
}

variable "log_analytics_name" {
  type = string
  default = "sastakehome-law"
}

variable "container_apps_env_name" {
  type = string
  default = "sastakehome-env"
}