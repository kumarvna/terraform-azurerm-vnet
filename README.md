# Azure Virtual Network Terraform Module

[![Terraform](https://img.shields.io/badge/Terraform%20-0.12.24-brightgreen.svg?style=flat)](https://github.com/hashicorp/terraform/releases) [![License](https://img.shields.io/badge/License%20-MIT-brightgreen.svg?style=flat)](https://github.com/kumarvna/cloudascode/blob/master/LICENSE)

Terraform Module to create a set of Azure network resources. Few of these resources added/excluded as per your requirement.

These types of resources are supported:

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)

* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)

* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)

* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)

* [Firewall](https://www.terraform.io/docs/providers/azurerm/r/firewall.html)


## Module Usage

```
provider "azurerm" {
    features {}
  }

module "virtualnetwork" {
  source                  = "../../"
  create_resource_group   = true
  create_network_watcher  = true

# Using Custom names and VNet/subnet Address Prefix (Recommended)
  resource_group_name     = "rg-demo-kumars-01"
  vnetwork_name           = "vnet-demo-westeurope-001"
  location                = "northeurope"
  vnet_address_space      =  ["10.1.0.0/16"]
  private_subnets         = ["snet-app01","snet-app02","snet-gw01"]
  subnet_address_prefix   = ["10.1.2.0/24","10.1.3.0/24","10.1.4.0/24"]

# Adding Network watcher, Firewall and custom DNS servers (Optional)
  create_ddos_plan        = false
  dns_servers             = []
  create_firewall         = false
  firewall_subnet_address_prefix = "10.1.1.0/24"

# Adding TAG's to your Azure resources (Required)
  application_name        = "TestApp1"
  owner_email             = "kumars@example.com"
  business_unit           = "publiccloud"
  costcenter_id           = "5847596"
  environment             = "development"
  customer_name           = "cloudascode"
}
```

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name` for custom naming conventions. If you want to create it using this module, set argument `create_resource_group = true`

## AzureNetwork DDoS Protection Plan

By default, this module will not create a DDoS Protection Plan. You can enable it by appending an argument `create_ddos_plan`. If you want to create a DDoS plan using this module, set argument `create_ddos_plan = true`

## Subnets

This module handles creation and a list of address spaces for subnets. Subnet creation is using `for_each` in resources new in terraform 0.12.6. 
When creating subnets, there is no way to "attach" them to a security group using this module. It is a conscious choice because of the deprecation of that field.

Instead use [Subnet security group assosciation](https://www.terraform.io/docs/providers/azurerm/r/subnet_network_security_group_association.html) outside the module.

It is also possible to add other routes to the associated route tables outside of this module.

## Network Watcher
This module handle the provision of Network Watcher. Note that you cannot create more than one network watcher resource per subscription in any region. 

By default, this enabled. You can exclude this from the Terraform plan using `create_network_watcher = false` argument in case you already have a network watcher available in your subscription.


## Firewall
This module manages the provision of the basic firewall. However, if you want to add rules, you have to include additional resources to attach needed custom/NAT/Application rules. 

To enable route to the internet from subnet via Azure Firewall, firewall has to be created first (`create_firewall = true`), then set `public_internet_route_next_hop_type = "VirtualAppliance"` and `public_internet_route_next_hop_in_ip_address = "AzureFirewall"` to the `azurerm_route_table` or `azurerm_route` resources. 


## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
create_resource_group | Whether to create resource group and use it for all networking resources | string | `"true"`
create_network | Controls if networking resources should be created (affects all resources) | string | `"true"`
create_ddos_plan | Controls if DDoS protection plan should be created | string | `"false"`
create_network_watcher|Controls if Network Watcher resources should be created for the Azure subscription |string|`"true"`
create_firewall |Whether to create firewall (incl. subnet and public IP)) |	string |`"false"`
firewall_subnet_address_prefix| Address prefix to use on firewall subnet. Default is a valid value, which should be overridden. | string |`"0.0.0.0/0"`
vnet_address_space|Virutal Nework address space to be used |list|`[]`
dns_servers | List of dns servers to use for virtual network | list |`[]`
location |Location where resource should be created |string |`""`
name | Name to use on resources | string |`""`
subnet_names|A list of subnets inside virtual network| list |`[]`
subnet_address_prefix|A list of subnets address prefixes inside virtual network| list |`[]`


## Outputs

Name | Description 
---- | -----------
resource_group_name | The name of the resource group in which resources are created
resource_group_id | The id of the resource group in which resources are created
resource_group_location| The location of the resource group in which resources are created
virtual_network_name | The name of the virtual network.
virtual_network_id |The virtual NetworkConfiguration ID.
virtual_network_address_space | List of address spaces that are used the virtual network.
subnet_ids | List of IDs of subnets
subnet_address_prefixes | List of address prefix for  subnets
ddos_protection_plan | Azure Network DDoS protection plan
network_watcher_id | ID of Network Watcher
firewall_id|The Resource ID of the Azure Firewall
firewall_public_ip_address|Public IP of firewall
firewall_subnet_address_prefixes|List of address prefix for firewall subnet
firewall_subnet_ids|List of IDs of firewall subnets

## Authors

Module is maintained by [Kumaraswamy Vithanala](mailto:kumaraswamy.vithanala@tieto.com) with the help from other awesome contributors.

## Other resources

* [Virtual network documentation (Azure Documentation)](https://docs.microsoft.com/en-us/azure/virtual-network/)

* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)

