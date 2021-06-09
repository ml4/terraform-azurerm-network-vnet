// amend the top section to work for your setup
module "network-vnet" {
  source   = "app.terraform.io/myorg/network-vnet/azurerm"
  version  = "1.0.xx"
  prefix   = "ml4"
  rg_name  = "rmg_test_net_rg"
  location = "West Europe"

  public_subnet_address_spaces = [
    {
      name          = "ml4-vnet-pub-asA"
      address_space = "10.0.0.0/24"
    },
    {
      name          = "ml4-vnet-pub-asB"
      address_space = "10.0.1.0/24"
    },
    {
      name          = "ml4-vnet-pub-asC"
      address_space = "10.0.2.0/24"
    }
  ]
  private_subnet_address_spaces = [
    {
      name          = "ml4-vnet-priv-asA"
      address_space = "10.0.3.0/24"
    },
    {
      name          = "ml4-vnet-priv-asB"
      address_space = "10.0.4.0/24"
    },
    {
      name          = "ml4-vnet-priv-asC"
      address_space = "10.0.5.0/24"
    }
  ]
}

