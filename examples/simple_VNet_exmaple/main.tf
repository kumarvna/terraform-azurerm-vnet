module "vnet" {
  // source  = "kumarvna/vnet/azurerm"
  // version = "1.3.0"
  source = "../../"
  # Using Custom names and VNet/subnet Address Prefix (Recommended)
  create_resource_group = true
  resource_group_name   = "rg-demo-westeurope-01"
  vnetwork_name         = "vnet-demo-westeurope-001"
  location              = "westeurope"
  vnet_address_space    = ["10.1.0.0/16"]

  # Multiple Subnets, Service delegation, Service Endpoints 
  subnets = {
    gw_subnet = {
      subnet_name           = "snet-gw01"
      subnet_address_prefix = ["10.1.2.0/24"]
    }

    app_subnet = {
      subnet_name           = "snet-app01"
      subnet_address_prefix = ["10.1.3.0/24"]
    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "test-user"
  }
}
