module "vnet" {
  source                = "kumarvna/vnet/azurerm"
  version               = "1.2.0"
  
  # Resource Group
  create_resource_group = false

  # Using Custom names and VNet/subnet Address Prefix (Recommended)
  resource_group_name   = "rg-demo-westeurope-01"
  vnetwork_name         = "vnet-demo-westeurope-001"
  location              = "westeurope"

  # Adding TAG's to your Azure resources (Required)
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "test-user"
  }
}