variable "create_network" {
    description = "Controls if networking resources should be created (it affects almost all resources)"
    default     = true
}

variable "create_resource_group" {
    description = "Whether to create resource group and use it for all networking resources"
    default     = false
}

variable "create_network_watcher" {
  description = "Whether to create network watcher"
  default     = true
}

variable "create_ddos_plan" {
    description = "Create an ddos plan - Default is false"
    default     = false
}

variable "create_firewall" {
    description = "Whether to create firewall (incl. subnet and public IP))"
    default     = false
}

variable "dns_servers" {
    description = "List of dns servers to use for virtual network"
    default     = []
}

variable "ddos_plan_name" {
    description = "The name of AzureNetwork DDoS Protection Plan"
    default     = "azureddosplan01"  
}

variable "resource_group_name" {
    description = "A container that holds related resources for an Azure solution"
    default     = "rg-azure-westeurope-01"
}

variable "location" {
    description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
    default     = "westeurope"
}

variable "vnetwork_name" {
    description = "Name of your Azure Virtual Network"
    default     = "vnet-azure-westeurope-001" 
}

variable "vnet_address_space" {
    description = "The address space to be used for the Azure virtual network."
    default = ["10.0.0.0/16"]
}

variable "private_subnets" {
    description = "A list the subnet names using a comma"
    default = ["snet_gw01","snet_app01","snet_app02"]
}

variable "subnet_address_prefix" {
    description ="A list of Subnet Prefixes to use along with subnet names"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
}

variable "firewall_subnet_address_prefix" {
    description = "Address prefix to use on firewall subnet. Default is a valid value, which should be overriden."
    default     = "0.0.0.0/0"
}

variable "netwatcher_name" {
    description = "The name of the Network Watcher"
    default = "netwatcher01"
}

variable "application_name" {
    description = "Please provide your application name"
    default     = ""
}

variable "owner_email" {
    description = "Please provide owner email for this environment"
    default     = ""
}

variable "environment" {
    description = "Please provide your application environment details here"
    default     = ""
}
