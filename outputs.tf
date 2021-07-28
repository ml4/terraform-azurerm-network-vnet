//// outputs.tf child module terraform configuration
//// Nomenclature: <d>-<e>-<f>-<g>[-<h>]
//// where
//// d = linked resource abbreviation (some resources in a mod are only there to support a main resource)
//// e = abbreviated resource
//// f = resource name
//// g = resource parameter to output
//// h = resource subparameter if applicable
//
//// and a, b and c get added in the root module
//
//// examples
//
// output "av-av-main-id" {
//   value       = aws_vpc.main.id
//   description = "AWS VPC: VPC ID"
// }
//

output "avn-as-public-subnets_id" {
  value       = azurerm_subnet.public[*].id
  description = "Azure VNet: Azure public Subnet IDs"
}

output "avn-as-private-subnets_id" {
  value       = azurerm_subnet.private[*].id
  description = "Azure VNet: Azure private Subnet IDs"
}
