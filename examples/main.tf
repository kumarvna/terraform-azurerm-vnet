provider "azurerm" {
    features {}
  }

module "virtualnetwork" {
  source                  = "../"
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