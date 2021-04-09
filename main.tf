//// main.tf terraform configuration
//
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.rg_name}"
  location = var.location
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-${var.sg_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_ddos_protection_plan" "main" {
  name                = "${var.prefix}-${var.ddos_plan_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-${var.vnet_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.address_space
  // dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.main.id
    enable = true
  }

  subnet {
    name           = "${var.prefix}-${var.subnet1_name}"
    address_prefix = var.subnet1_address_prefix
    security_group = azurerm_network_security_group.main.id
  }

// keep simple for now
  // subnet {
  //   name           = "subnet2"
  //   address_prefix = "10.0.2.0/24"
  // }

  // subnet {
  //   name           = "subnet3"
  //   address_prefix = "10.0.3.0/24"
  // }
  tags = merge({ Name = "${var.prefix}-vnet" }, var.common_tags)
}
