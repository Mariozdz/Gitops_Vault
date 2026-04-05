terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-aks"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "uami-aks-cilium"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "aks_subnet_network_contributor" {
  scope                = azurerm_subnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cilium"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akscilium"

  sku_tier = "Free"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    vnet_subnet_id  = azurerm_subnet.subnet.id
    os_disk_size_gb = 30
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    load_balancer_sku   = "standard"
    service_cidr        = "10.2.0.0/24"
    dns_service_ip      = "10.2.0.10"
  }

  api_server_access_profile {
    authorized_ip_ranges = [var.my_public_ip_cidr]
  }

  tags = {
    environment = "lab"
    managed-by  = "terraform"
  }

  depends_on = [azurerm_role_assignment.aks_subnet_network_contributor]
}