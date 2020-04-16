#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
locals {
  common_tags = {
    "ApplicationName"   = var.application_name
    "Owner"             = var.owner_email
    "Environment"       = var.environment
  }
  resource_group_name = element(
    coalescelist(azurerm_resource_group.rg.*.name, [""]), 0)

  virtual_network_name = element(
    concat(azurerm_virtual_network.vnet.*.name, [""]), 0)

  if_ddos_enabled = var.create_ddos_plan ? [{}] : []  
}

resource "azurerm_resource_group" "rg" {
  count                 = var.create_network && var.create_resource_group ? 1 : 0
  name                  = var.resource_group_name
  location              = var.location
  tags                  = local.common_tags
}

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  count                 = var.create_network ? 1 : 0
  name                  = var.vnetwork_name
  location              = var.location
  resource_group_name   = local.resource_group_name
  address_space         = var.vnet_address_space
  dns_servers           = var.dns_servers
  tags                  = local.common_tags
  
  dynamic "ddos_protection_plan" {
    for_each = local.if_ddos_enabled
  
    content {
      id     = azurerm_network_ddos_protection_plan.ddos[0].id
      enable = true
    }
  }
}

#--------------------------------------------
# Ddos protection plan - Default is "false"
#--------------------------------------------

resource "azurerm_network_ddos_protection_plan" "ddos" {
  count                 = var.create_ddos_plan ? 1 : 0
  name                  = var.ddos_plan_name
  resource_group_name   = local.resource_group_name
  location              = var.location
  tags                  = local.common_tags
}

#--------------------------------------------
# Subnets Creation - Depends on VNET Resource
#--------------------------------------------

resource "azurerm_subnet" "subnets" {
  name                  = var.private_subnets[count.index]
  resource_group_name   = local.resource_group_name
  virtual_network_name  = local.virtual_network_name
  address_prefix        = var.subnet_address_prefix[count.index]
  count                 = length(var.private_subnets)  
}

#-------------------------------------
# Network Watcher - Default is "false"
#-------------------------------------
resource "azurerm_network_watcher" "netwatcher" {
  count                 = var.create_network && var.create_network_watcher ? 1 : 0
  name                  = var.netwatcher_name
  location              = var.location
  resource_group_name   = local.resource_group_name
  tags                  = local.common_tags
}

#-------------------------------------
# Firewall - Default is "false"
#-------------------------------------
resource "azurerm_subnet" "fw-subnet" {
  count                 = var.create_network && var.create_firewall ? 1 : 0
  name                  = "AzureFirewallSubnet"
  resource_group_name   = local.resource_group_name
  address_prefix        = var.firewall_subnet_address_prefix
  virtual_network_name  = local.virtual_network_name
} 

resource "azurerm_public_ip" "fw-pip" {
  count                 = var.create_network && var.create_firewall ? 1 : 0
  name                  = "pip-firewall-01"
  location              = var.location
  resource_group_name   = local.resource_group_name
  allocation_method     = "Static"
  sku                   = "Standard"
  tags                  = local.common_tags
}

resource "azurerm_firewall" "firewall" {
  count                 = var.create_network && var.create_firewall ? 1 : 0
  name                  = "firewall01"
  location              = var.location
  resource_group_name   = local.resource_group_name
  ip_configuration {
    name                 = "firewall-ip01"
    subnet_id            = element(azurerm_subnet.fw-subnet.*.id, 0)
    public_ip_address_id = element(azurerm_public_ip.fw-pip.*.id, 0)
  }
  tags                  = local.common_tags
}

