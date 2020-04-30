module "virtualnetwork" {
  source                  = "github.com/tietoevry-infra-as-code/terraform-azurerm-vnet?ref=v1.0.0"
  create_resource_group = false

# Using Custom names and VNet/subnet Address Prefix (Recommended)
  resource_group_name   = "rg-demo-westeurope-01"
  vnetwork_name         = "vnet-demo-westeurope-001"
  location              = "westeurope"

# Adding TAG's to your Azure resources (Required)
  tags                  = {
    application_name    = "demoapp01"
    owner_email         = "user@example.com"
    business_unit       = "publiccloud"
    costcenter_id       = "5847596"
    environment         = "development"
}