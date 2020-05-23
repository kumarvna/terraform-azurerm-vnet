# Azure Virtual Network Terraform Module

Terraform Module to create a set of Azure network resources. Few of these resources added/excluded as per your requirement.

These types of resources are supported:

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Subnet Service Delegation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#delegation)
* [Virtual Network service endpoints](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_endpoints)
* [AzureNetwork DDoS Protection Plan](https://www.terraform.io/docs/providers/azurerm/r/network_ddos_protection_plan.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)


## Module Usage

Following example to create a virtual network with subnets, NSG, DDoS protection plan, and network watcher resources.

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # Using Custom names and VNet/subnet Address Prefix (Recommended)
  create_resource_group = false
  resource_group_name   = "rg-demo-westeurope-01"
  vnetwork_name         = "vnet-demo-westeurope-001"
  location              = "westeurope"
  vnet_address_space    = ["10.1.0.0/16"]

  # Adding Standard DDoS Plan, and custom DNS servers (Optional)
  create_ddos_plan = true
  dns_servers      = []

  # Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"
      delegation = {
        name = "demodelegationcg"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values. (Applicable to destination_port_range, source_address_prefix, destination_address_prefix, description).
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "0.0.0.0/0", "http_80"],
        ["weballow1", "101", "Inbound", "Allow", "", "443", "*", "", "https_443"],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "8080-8090", "*", ""],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values. (Applicable to destination_port_range, source_address_prefix, destination_address_prefix, description).
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0", ""],
      ]
    }

    app_subnet = {
      subnet_name           = "snet-app01"
      subnet_address_prefix = "10.1.3.0/24"
      service_endpoints     = ["Microsoft.Storage"]

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values. (Applicable to destination_port_range, source_address_prefix, destination_address_prefix, description).
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "", "http_80"],
        ["weballow1", "101", "Inbound", "Allow", "Tcp", "443", "AzureLoadBalancer", "", "https_443"],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "9090", "VirtualNetwork", "", "http_9090"],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values. (Applicable to destination_port_range, source_address_prefix, destination_address_prefix, description).
      ]
    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "test-user"
  }
}
```

## Create resource group

By default, this module will not create a resource group and the name of an existing resource group to be given in an argument `resource_group_name`. If you want to create a new resource group, set the argument `create_resource_group = true`.

*If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Azure Network DDoS Protection Plan

By default, this module will not create a DDoS Protection Plan. You can enable it by appending an argument `create_ddos_plan`. If you want to create a DDoS plan using this module, set argument `create_ddos_plan = true`

## Subnets

This module handles the creation and a list of address spaces for subnets. The subnet creation is using `for_each` to create subnets and corresponding service endpoints, service delegation, and network security groups. This module associates the subnets to network security groups as well.  

It is also possible to add other routes to the associated route tables outside of this module.

## Virtual Network service endpoints

Service Endpoints allows connecting certain platform services into virtual networks.  With this option, Azure virtual machines can interact with Azure SQL and Azure Storage accounts, as if they’re part of the same virtual network, rather than Azure virtual machines accessing them over the public endpoint.

This module supports enabling the service endpoint of your choosing under the virtual network and with the specified subnet. The list of Service endpoints to associate with the subnet values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"

      service_endpoints     = ["Microsoft.Storage"]  
    }
  }

# ....omitted

}
```

## Subnet Service Endpoints

Subnet delegation enables you to designate a specific subnet for an Azure PaaS service of your choice that needs to be injected into your virtual network. The Subnet delegation provides full control to manage the integration of Azure services into virtual networks.

This module supports enabling the service delegation of your choosing under the virtual network and with the specified subnet.  For more information, check the [terraform resource documentation](https://www.terraform.io/docs/providers/azurerm/r/subnet.html#service_delegation).

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"

      delegation = {
        name = "demodelegationcg"
        service_delegation = {
          name    = "Microsoft.ContainerInstance/containerGroups"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    }
  }

# ....omitted

}
```

## `enforce_private_link_endpoint_network_policies` - Private Link Endpoint on the subnet

Network policies, like network security groups (NSG), are not supported for Private Link Endpoints=. In order to deploy a Private Link Endpoint on a given subnet, you must set the `enforce_private_link_endpoint_network_policies` attribute to `true`. This setting is only applicable for the Private Link Endpoint, for all other resources in the subnet access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource. 

This module Enable or Disable network policies for the private link endpoint on the subnet. The default value is `false`. If you are enabling the Private Link Endpoints on the subnet you shouldn't use Private Link Services as it's conflicts. 

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"
      enforce_private_link_endpoint_network_policies = true

        }
      }
    }
  }

# ....omitted

}
```

## `enforce_private_link_service_network_policies` - private link service on the subnet

In order to deploy a Private Link Service on a given subnet, you must set the `enforce_private_link_service_network_policies` attribute to `true`. This setting is only applicable for the Private Link Service, for all other resources in the subnet access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.

This module Enable or Disable network policies for the private link service on the subnet. The default value is `false`. If you are enabling the Private Link service on the subnet then, you shouldn't use Private Link endpoints as it's conflicts. 

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"
      enforce_private_link_endpoint_network_policies = true

        }
      }
    }
  }

# ....omitted

}
```

## Network Watcher

This module handle the provision of Network Watcher. Note that you cannot create more than one network watcher resource per subscription in any region.

By default, this enabled to create the necessary resources in that region. You can exclude this from the Terraform plan using `create_network_watcher = false` argument in case you already have a network watcher available in your subscription.

## Network Security Groups

By default, the network security groups connected to Management and ApplicationGateway will only allow necessary traffic and block everything else (deny-all rule). Use `nsg_inbound_rules` and `nsg_outbound_rules` in this Terraform module to create a Network Security Group (NSG) for each subnet and allow it to add additional rules for inbound flows.

In the Source and Destination columns, `VirtualNetwork`, `AzureLoadBalancer`, and `Internet` are service tags, rather than IP addresses. In the protocol column, Any encompasses `TCP`, `UDP`, and `ICMP`. When creating a rule, you can specify `TCP`, `UDP`, `ICMP` or `*`. `0.0.0.0/0` in the Source and Destination columns represents all addresses.

*You cannot remove the default rules, but you can override them by creating rules with higher priorities.*

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # .... omitted

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"

     nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values (Applicable to destination_port_range, source_address_prefix, destination_address_prefix, description).
        ["weballow", "100", "Inbound", "Allow", "Tcp", "80", "*", "", "http_80"],
        ["weballow1", "101", "Inbound", "Allow", "Tcp", "443", "AzureLoadBalancer", "", "https_443"],
        ["weballow2", "102", "Inbound", "Allow", "Tcp", "9090", "VirtualNetwork", "", "http_9090"],
      ] 

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]
        # To use defaults, use "" without adding any values. (Applicable to protocol, destination_port_range, source_address_prefix, destination_address_prefix, description) 
        ["ntp_out", "103", "Outbound", "Allow", "Udp", "123", "", "0.0.0.0/0", ""],
      ]
    }
  }
}
```

## Tagging

Use tags to organize your Azure resources and management hierarchy. You can apply tags to your Azure resources, resource groups, and subscriptions to logically organize them into a taxonomy. Each tag consists of a name and a value pair. For example, you can apply the name "Environment" and the value "Production" to all the resources in production. You can manage these values variables directly or mapping as a variable using `variables.tf`.

All Azure resources which support tagging can be tagged by specifying key-values in argument `tags`. Tag Name is added automatically on all resources. For example, you can specify `tags` like this:

```
module "vnet" {
  source  = "kumarvna/vnet/azurerm"
  version = "1.3.0"

  # ... omitted

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "test-user"
  }
}  
```

## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`create_resource_group` | Whether to create resource group and use it for all networking resources | string | `"false"`
`resource_group_name` | The name of the resource group in which resources are created | string | `""`
`location`|The location of the resource group in which resources are created| string | `""`
`vnetwork_name`|The name of the virtual network| string | `""`
`vnet_address_space`|Virutal Nework address space to be used |list|`[]`
`dns_servers` | List of dns servers to use for virtual network | list |`[]`
`subnets`|For each subnet, create an object that contain fields|object|`{}`
`subnet_name`|A name of subnets inside virtual network| object |`{}`
`subnet_address_prefix`|A list of subnets address prefixes inside virtual network| list |`{}`
`delegation`|defines a subnet delegation feature. takes an object as described in the following example|object|`{}`
`service_endpoints`|service endpoints for the virtual subnet|object|`{}`
`nsg_inbound_rule`|network security groups settings - a NSG is always created for each subnet|object|`{}`
`nsg_outbound_rule`|network security groups settings - a NSG is always created for each subnet|object|`{}`
`create_ddos_plan` | Controls if DDoS protection plan should be created | string | `"false"`
`ddos_plan_name`|Name of Azure Network DDoS protection plan| string | `""`
`create_network_watcher`|Controls if Network Watcher resources should be created for the Azure subscription |string|`"true"`
`netwatcher_name`|The name of the Network Watcher| string |`""`
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
`network_security_group_ids`|List of Network security groups and ids
`network_security_group`|Network security group details - Useful for splat expression.
`ddos_protection_plan` | Azure Network DDoS protection plan
`network_watcher_id` | ID of Network Watcher

## Resource Graph

![Resource Graph](graph.png)

## Authors

Module is maintained by [Kumaraswamy Vithanala](mailto:kumarvna@gmail.com) with the help from other awesome contributors.

## Other resources

* [Virtual network documentation (Azure Documentation)](https://docs.microsoft.com/en-us/azure/virtual-network/)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
