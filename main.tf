#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
locals {
  resource_group_name = element(
    coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)

  location = element(
    coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)

  virtual_network_name = element(
    concat(azurerm_virtual_network.vnet.*.name, [""]), 0)

  if_ddos_enabled = var.create_ddos_plan ? [{}] : []  
}

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name = "${var.resource_group_name}"
}

resource "azurerm_resource_group" "rg" {
  count                 = var.create_resource_group ? 1 : 0
  name                  = var.resource_group_name
  location              = var.location
  tags                  = merge({"Name" = format("%s", var.resource_group_name)}, var.tags,)
}

#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  count                 = var.create_network ? 1 : 0
  name                  = var.vnetwork_name
  location              = local.location
  resource_group_name   = local.resource_group_name
  address_space         = var.vnet_address_space
  dns_servers           = var.dns_servers
  tags                  = merge({"Name" = format("%s", var.vnetwork_name)}, var.tags,)
  
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
  location              = local.location
  tags                  = merge({"Name" = format("%s", var.ddos_plan_name)}, var.tags,)
}

#--------------------------------------------
# Subnets Creation - Depends on VNET Resource
#--------------------------------------------

resource "azurerm_subnet" "snets" {
  name                  = var.private_subnets[count.index]
  resource_group_name   = local.resource_group_name
  virtual_network_name  = local.virtual_network_name
  address_prefix        = var.subnet_address_prefix[count.index]
  count                 = length(var.private_subnets)  
}

#-------------------------------------
# Network Watcher - Default is "false"
#-------------------------------------
resource "azurerm_network_watcher" "nwatcher" {
  count                 = var.create_network && var.create_network_watcher ? 1 : 0
  name                  = var.netwatcher_name
  location              = local.location
  resource_group_name   = local.resource_group_name
  tags                  = merge({"Name" = format("%s", var.netwatcher_name)}, var.tags,)
}