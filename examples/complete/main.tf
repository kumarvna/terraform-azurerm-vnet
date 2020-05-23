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
