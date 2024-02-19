
## main.tf terraform configuration
#
resource "random_string" "main" {
  count   = var.random_string != null ? 0 : 1
  length  = 4
  special = false
  numeric = false
  upper   = false
}

resource "azurerm_resource_group" "vnet_rg" {
  count    = var.resource_group_name != null ? 0 : 1
  name     = "${var.friendly_name_prefix}-vnet-rg-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  location = var.location
}

resource "azurerm_virtual_network" "networking" {
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  location            = var.location
  name                = "${var.friendly_name_prefix}-vnet-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

## public subnet - defined by the security rules defined below
#
resource "azurerm_subnet" "public" {
  resource_group_name  = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  virtual_network_name = azurerm_virtual_network.networking.name
  count                = length(var.public_subnet_address_spaces)
  name                 = "${var.public_subnet_address_spaces[count.index].name}-subnet-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  address_prefixes     = [var.public_subnet_address_spaces[count.index].address_space]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_network_security_group" "public" {
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  location            = var.location
  name                = "${var.friendly_name_prefix}-public-nsg-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  tags                = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = length(var.public_subnet_address_spaces)
  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.public.id
}

## RDP traffic
#
resource "azurerm_network_security_rule" "rule-rdp-public" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-rdp-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow RDP (3389) traffic"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*" # this should be locked down but is kept open for ease of starting/experimentation
  destination_address_prefix  = "*"
}

## Allows SSH from allowed IPs - consider switching to a non-standard port or disabling for immutable infrastructure
#
resource "azurerm_network_security_rule" "rule-ssh-public" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-ssh-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "SSH open for debugging"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*" # this should be locked down but is kept open for ease of starting/experimentation
  destination_address_prefix  = "*"
}

## Allows CIFS from allowed IPs
#
resource "azurerm_network_security_rule" "rule-cifs-public" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-cifs-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow CIFS"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = "*" # this should be locked down but is kept open for ease of starting/experimentation
  destination_address_prefix  = "*"
}

## HTTP traffic - UNENCRYPTED WEB TRAFFIC: we advise redirection to HTTPS
#
resource "azurerm_network_security_rule" "rule-http-application-public" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-http-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow HTTP (80) traffic"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*" # this should be locked down but is kept open for ease of starting/experimentation
  destination_address_prefix  = "*"
}

## HTTPS traffic
#
resource "azurerm_network_security_rule" "rule-https-application-public" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-https-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow HTTPS (443) traffic"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

#############################################

## private subnet -  - defined by the security rules defined below
#
resource "azurerm_subnet" "private" {
  resource_group_name  = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  virtual_network_name = azurerm_virtual_network.networking.name
  count                = length(var.private_subnet_address_spaces)
  name                 = "${var.private_subnet_address_spaces[count.index].name}-subnet-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  address_prefixes     = [var.private_subnet_address_spaces[count.index].address_space]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_network_security_group" "private" {
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  location            = var.location
  name                = "${var.friendly_name_prefix}-private-nsg-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  tags                = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = length(var.private_subnet_address_spaces)
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private.id
}

## RDP traffic
#
resource "azurerm_network_security_rule" "rule-rdp-private" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.private.name
  name                        = "ansr-rdp-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow RDP (3389) traffic"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.0.0.0/16" # access from private IP addresses only
  destination_address_prefix  = "*"
}

## Allows SSH from allowed IPs - consider switching to a non-standard port or disabling for immutable infrastructure
#
resource "azurerm_network_security_rule" "rule-ssh-private" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.private.name
  name                        = "ansr-ssh-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "SSH open for debugging"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.0.0/16" # access from private IP addresses only
  destination_address_prefix  = "*"
}

## Allows Postgres from allowed IPs
#
resource "azurerm_network_security_rule" "rule-postgres-private" {
  resource_group_name         = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.vnet_rg[0].name
  network_security_group_name = azurerm_network_security_group.public.name
  name                        = "ansr-postgres-${var.random_string != null ? var.random_string : random_string.main[0].result}"
  description                 = "Allow PostgreSQL"
  priority                    = 202
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "10.0.0.0/16" # access from private IP addresses only
  destination_address_prefix  = "*"
}
