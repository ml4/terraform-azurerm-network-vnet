variable "prefix" {
  type        = string
  description = "Main prefix for all objects"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location to deploy to"
  default     = "West Europe"
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for taggable resources."
  default     = {}
}

variable "vnet_address_space" {
  type = list(string)
  description = "(Optional) list of vnet address ranges"
  default = ["10.0.0.0/16"]
}

variable "subnet_address_spaces" {
  type = list(string)
  description = "(Optional) list of subnet address ranges"
  default = ["10.0.1.0/16"]
}
