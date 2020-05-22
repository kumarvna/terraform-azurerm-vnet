# Virtual Network resource creation example

Configuration in this directory creates a set of Azure network resources. Few of these resources added/excluded as per your requirement.

## Module Usage

Following example to create a simple virtual network with subnets and network watcher resources. Please see the complete example to add rest of the features in this module. 

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

  # Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = "10.1.2.0/24"
    }

    app_subnet = {
      subnet_name           = "snet-app01"
      subnet_address_prefix = "10.1.3.0/24"
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