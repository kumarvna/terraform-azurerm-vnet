# Azure Virtual Network Terraform Module

[![Terraform](https://img.shields.io/badge/Terraform%20-0.12-brightgreen.svg?style=flat)](https://github.com/hashicorp/terraform/releases) [![License](https://img.shields.io/badge/License%20-MIT-brightgreen.svg?style=flat)](https://github.com/kumarvna/cloudascode/blob/master/LICENSE)

Terraform Module to create a set of Azure network resources. Few of these resources added/excluded as per your requirement.

These types of resources are supported:

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)

* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)

* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)

* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)

## Module Usage

## Basic VNet

Following example to create a virtual network with subnets and network watcher resources.

```
module "virtualnetwork" {
  source                  = "github.com/kumarvna/terraform-azurerm-vnet?ref=v1.2.0"
  create_resource_group   = false

# Using Custom names and VNet/subnet Address Prefix (Recommended)
  resource_group_name     = "rg-demo-westeurope-01"
  vnetwork_name           = "vnet-demo-westeurope-001"
  location                = "westeurope"

# Adding TAG's to your Azure resources (Required)
  tags                    = {
    application_name      = "demoapp01"
    owner_email           = "user@example.com"
    business_unit         = "publiccloud"
    costcenter_id         = "5847596"
    environment           = "development"
  }
}
```

## Create resource group

By default, this module will not create a resource group and the name of an existing resource group to be given in an argument `create_resource_group`. If you want to create a new resource group, set the argument `create_resource_group = true`.

*If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Azure Network DDoS Protection Plan

By default, this module will not create a DDoS Protection Plan. You can enable it by appending an argument `create_ddos_plan`. If you want to create a DDoS plan using this module, set argument `create_ddos_plan = true`

## Subnets

This module handles creation and a list of address spaces for subnets. Subnet creation is using `for_each` in resources new in terraform 0.12.6 and will be updated in future versions. When creating subnets, there is no way to "attach" them to a security group using this module. It is a conscious choice because of the deprecation of that field.

Instead use [Subnet security group association](https://www.terraform.io/docs/providers/azurerm/r/subnet_network_security_group_association.html) outside the module.

It is also possible to add other routes to the associated route tables outside of this module.

## Network Watcher

This module handle the provision of Network Watcher. Note that you cannot create more than one network watcher resource per subscription in any region.

By default, this enabled. You can exclude this from the Terraform plan using `create_network_watcher = false` argument in case you already have a network watcher available in your subscription.

## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`create_resource_group` | Whether to create resource group and use it for all networking resources | string | `"false"`
`create_network` | Controls if networking resources should be created (affects all resources) | string | `"true"`
`create_ddos_plan` | Controls if DDoS protection plan should be created | string | `"false"`
`create_network_watcher`|Controls if Network Watcher resources should be created for the Azure subscription |string|`"true"`
`vnet_address_space`|Virutal Nework address space to be used |list|`[]`
`dns_servers` | List of dns servers to use for virtual network | list |`[]`
`location` |Location where resource should be created |string |`""`
`name` | Name to use on resources | string |`""`
`subnet_names`|A list of subnets inside virtual network| list |`[]`
`subnet_address_prefix`|A list of subnets address prefixes inside virtual network| list |`[]`
`Tags`|A map of tags to add to all resources|map|`{}`

## Outputs

Name | Description
---- | -----------
`resource_group_name` | The name of the resource group in which resources are created
`resource_group_id` | The id of the resource group in which resources are created
`resource_group_location`| The location of the resource group in which resources are created
`virtual_network_name` | The name of the virtual network.
`virtual_network_id` |The virtual NetworkConfiguration ID.
`virtual_network_address_space` | List of address spaces that are used the virtual network.
`subnet_ids` | List of IDs of subnets
`subnet_address_prefixes` | List of address prefix for  subnets
`ddos_protection_plan` | Azure Network DDoS protection plan
`network_watcher_id` | ID of Network Watcher

## Resource Graph

![Resource Graph](graph.png)

## Authors

Module is maintained by [Kumaraswamy Vithanala](mailto:kumarvna@gmail.com) with the help from other awesome contributors.

## Other resources

* [Virtual network documentation (Azure Documentation)](https://docs.microsoft.com/en-us/azure/virtual-network/)

* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
