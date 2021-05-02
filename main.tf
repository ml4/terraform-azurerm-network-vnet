//// main.tf terraform configuration
//
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.rg_name}"
  location = var.location
}

resource "azurerm_virtual_network" "networking" {
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = "${var.prefix}-vnet"
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "networking" {
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.networking.name
  count                = length(var.subnet_address_spaces)
  name                 = "${var.subnet_address_spaces[count.index].name}-subnet"
  address_prefixes     = [var.subnet_address_spaces[count.index].address_space]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
  # NSG must be assigned twice. See issue https://github.com/terraform-providers/terraform-provider-azurerm/issues/2526
  network_security_group_id = azurerm_network_security_group.networking.id
}

resource "azurerm_network_security_group" "networking" {
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = "${var.prefix}-nsg"
  tags                = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "networking" {
  count                     = length(var.subnet_address_spaces)
  subnet_id                 = azurerm_subnet.networking[count.index].id
  network_security_group_id = azurerm_network_security_group.networking.id
}

// # Only allows SSH from white list IPs
// resource "azurerm_network_security_rule" "rule-SSH" {
//   resource_group_name         = var.rg_name
//   network_security_group_name = azurerm_network_security_group.networking.name
//   count                       = length(var.public_ip_allowlist)
//   name                        = "SSH-${count.index}"
//   description                 = "SSH open for debugging from: ${var.public_ip_allowlist[count.index]}"
//   priority                    = 100 + count.index
//   direction                   = "Inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "22"
//   source_address_prefix       = var.public_ip_allowlist[count.index]
//   destination_address_prefix  = "*"
// }

// resource "azurerm_network_security_rule" "rule-tfe-application" {
//   resource_group_name         = var.rg_name
//   network_security_group_name = azurerm_network_security_group.networking.name
//   name                        = "TFEApp"
//   description                 = "Allow HTTPS (443) traffic for the TFE Application."
//   priority                    = 1000
//   direction                   = "Inbound"
//   access                      = "Allow"
//   protocol                    = "Tcp"
//   source_port_range           = "*"
//   destination_port_range      = "443"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
// }

// // resource "azurerm_network_security_rule" "rule-tfe-console" {
// //   resource_group_name         = var.rg_name
// //   network_security_group_name = azurerm_network_security_group.networking.name
// //   name                        = "TFEConsole"
// //   description                 = "Allow port 8800 traffic for the TFE Console."
// //   priority                    = 1001
// //   direction                   = "Inbound"
// //   access                      = "Allow"
// //   protocol                    = "Tcp"
// //   source_port_range           = "*"
// //   destination_port_range      = "8800"
// //   source_address_prefix       = "*"
// //   destination_address_prefix  = "*"
// // }

// # Needed for Application Gateway rule on vnet
// resource "azurerm_network_security_rule" "rule-nsg" {
//   resource_group_name         = var.rg_name
//   network_security_group_name = azurerm_network_security_group.networking.name
//   name                        = "nsg"
//   description                 = "Port range required for Azure infrastructure communication."
//   priority                    = 500
//   direction                   = "Inbound"
//   access                      = "Allow"
//   protocol                    = "*"
//   source_port_range           = "*"
//   destination_port_range      = "65200-65535"
//   source_address_prefix       = "*"
//   destination_address_prefix  = "*"
// }