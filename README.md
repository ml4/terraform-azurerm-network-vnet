# terraform-azurerm-network-vnet
Terraform child module to manage Azure vnets.
Kudos to Tom Straub.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rule-cifs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rule-http-application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rule-https-application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rule-postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rule-rdp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.rule-ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.networking](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Map of common tags for taggable resources. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy to | `string` | `"West Europe"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Main prefix for all objects | `string` | n/a | yes |
| <a name="input_private_subnet_address_spaces"></a> [private\_subnet\_address\_spaces](#input\_private\_subnet\_address\_spaces) | A list of privately accessible subnet address spaces and names. | <pre>list(object({<br>    name          = string<br>    address_space = string<br>  }))</pre> | n/a | yes |
| <a name="input_public_subnet_address_spaces"></a> [public\_subnet\_address\_spaces](#input\_public\_subnet\_address\_spaces) | A list of publically accessible subnet address spaces and names. | <pre>list(object({<br>    name          = string<br>    address_space = string<br>  }))</pre> | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | (Optional) list of vnet address ranges | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_avn-avn-main-subnet-id"></a> [avn-avn-main-subnet-id](#output\_avn-avn-main-subnet-id) | VNet subnet ID(s) |
<!-- END_TF_DOCS -->
