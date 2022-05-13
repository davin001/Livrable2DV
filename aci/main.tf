terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
terraform {
  backend "azurerm" {
    resource_group_name  = "terraformdv"
    storage_account_name = "tfstatetp2dv"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
variable "location" {
  type        = string
  description = "Location of Azure resources"
  default     = "canadaeast"
}
variable "location1" {
  type        = string
  description = "Location of Azure resources"
  default     = "westus"
}
variable "location2" {
  type        = string
  description = "Location of Azure resources"
  default     = "westuk"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
  default     = "Livrable2DV"
}
variable "resource_group_name1" {
  type        = string
  description = "Resource Group name RG1"
  default     = "Livrable2DV-RG1"
}
variable "resource_group_name2" {
  type        = string
  description = "Resource Group RG2"
  default     = "Livrable2DV-RG2"
}
variable "container_group_name" {
  type        = string
  description = "aci name"
  default     = "nginx"
}
variable "container_group_dns" {
  type        = string
  description = "aci name"
  default     = "TP2-DV"
}
resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_resource_group" "RG1" {
  name     = var.resource_group_name1
  location = var.location
}
resource "azurerm_resource_group" "RG2" {
  name     = var.resource_group_name2
  location = var.location
}
resource "azurerm_container_group" "aci" {
  name                = var.container_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_address_type     = "Public"
  dns_name_label      = var.container_group_dns
  os_type             = "Linux"
  container {
    name   = "nginx"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  depends_on = [
    azurerm_resource_group.demo,
  ]
}
