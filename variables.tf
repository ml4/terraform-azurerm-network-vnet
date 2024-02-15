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
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for taggable resources."
  default     = {}
}

variable "vnet_address_space" {
  type        = list(string)
  description = "(Optional) list of vnet address ranges"
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_address_spaces" {
  description = "A list of publically accessible subnet address spaces and names."
  type = list(object({
    name          = string
    address_space = string
  }))
}

variable "private_subnet_address_spaces" {
  description = "A list of privately accessible subnet address spaces and names."
  type = list(object({
    name          = string
    address_space = string
  }))
}
