## outputs.tf root module terraform configuration
## Nomenclature: <a>-<b>-<c>-<e>-<f>-<g>-<h>-<i>
## where
## a = 'What is the function of this cfg?'
## b = Abbreviated underlying/child module name
## c = Reasonably free text description in snake case
## d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
## e = abbreviated resource
## f = resource name
## g = resource parameter to output
## h = resource subparameter if applicable
#
## examples
#
# output "network-av-special_vpc-av-av-main-id" {
#   value       = module.my-mod.av-av-main-id
#   description = "AWS VPC: VPC ID"
# }
#

output "network-avn-3tier_stack-avn-as-public-subnet_id" {
  value       = module.network-vnet.avn-as-public-subnet_id
  description = "Azure VNet: Azure public Subnet IDs"
}

output "network-avn-3tier_stack-avn-as-private-subnet_id" {
  value       = module.network-vnet.avn-as-private-subnet_id
  description = "Azure VNet: Azure private Subnet IDs"
}
