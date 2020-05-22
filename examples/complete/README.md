# Virtual Network resource creation example

Configuration in this directory creates a set of Azure network resources. Few of these resources added/excluded as per your requirement.

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

  # Adding Network watcher, and custom DNS servers (Optional)
  create_ddos_plan = true
  dns_servers      = ["8.8.8.8", "4.4.4.4"]

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
      nsg_inbound_rule = [
        # [name, priority, destination_port_range, source_address_prefix]"
        ["weballow", "100", "80", "*"],
        ["weballow1", "101", "443", "*"],
        ["weballow2", "102", "8080-8090", "*"],
      ]
    }

    app_subnet = {
      subnet_name           = "snet-app01"
      subnet_address_prefix = "10.1.3.0/24"
      service_endpoints     = ["Microsoft.Storage"]

      nsg_inbound_rule = [
        # [name, priority, destination_port_range, source_address_prefix]"
        ["weballow", "100", "80", "*"],
        ["weballow1", "101", "443", "AzureLoadBalancer"],
        ["weballow2", "102", "9090", "VirtualNetwork"],
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

## Terraform Usage

To run this example you need to execute following Terraform commands

```
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.