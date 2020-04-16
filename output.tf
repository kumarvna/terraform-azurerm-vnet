# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"  
  value = element(
    coalescelist(azurerm_resource_group.rg.*.name, [""],), 0,)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"  
  value = element(
    coalescelist(azurerm_resource_group.rg.*.id, [""],), 0,)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"  
  value = element(
    coalescelist(azurerm_resource_group.rg.*.location, [""],), 0,)
}

# Vnet and Subnets

output "virtual_network_name" {
  description = "The name of the virtual network"  
  value = element(concat(azurerm_virtual_network.vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"  
  value = element(concat(azurerm_virtual_network.vnet.*.id, [""]), 0)
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value = [flatten(azurerm_virtual_network.vnet.*.address_space)]
}

output "subnet_ids" {
  description = "List of IDs of subnets"  
  value = [flatten(azurerm_subnet.subnets.*.id)]
}

output "subnet_address_prefixes" {
  description = "List of address prefix for subnets"  
  value = [flatten(azurerm_subnet.subnets.*.address_prefix)]
}

# DDoS Protection Plan
output "ddos_protection_plan" {
  description = "Ddos protection plan details"
  value       = azurerm_network_ddos_protection_plan.ddos
  depends_on = [azurerm_network_ddos_protection_plan.ddos,]
}

# Network Watcher
output "network_watcher_id" {
  description = "ID of Network Watcher"
  value = element(concat(azurerm_network_watcher.netwatcher.*.id, [""]), 0)
}

# Firewall
output "firewall_id" {
  description = "The Resource ID of the Azure Firewall"
  value       = element(concat(azurerm_firewall.firewall.*.id, [""]), 0)
}

output "firewall_subnet_ids" {
  description = "List of IDs of firewall subnets"
  value       = [flatten(azurerm_subnet.fw-subnet.*.id)]
}

output "firewall_subnet_address_prefixes" {
  description = "List of address prefix for firewall subnets"
  value       = [flatten(azurerm_subnet.fw-subnet.*.address_prefix)]
}

output "firewall_public_ip_address" {
  description = "Public IP of firewall"
  value       = element(concat(azurerm_public_ip.fw-pip.*.ip_address, [""]), 0)
}
