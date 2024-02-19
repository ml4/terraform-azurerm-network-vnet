variable "friendly_name_prefix" {
  type        = string
  description = "Prefix used to name Azure resources uniquely."

  validation {
    condition     = !strcontains(var.friendly_name_prefix, "vnet")
    error_message = "The prefix should not contain 'vnet'."
  }

  validation { # needs 0.13+
    condition = (
      length(var.friendly_name_prefix) <= 12
    )
    error_message = "Variable is too long, 12 chars max."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the resources will be created"
  default     = null
}

variable "location" {
  type        = string
  description = "The Azure region to deploy all infrastructure to."

  validation {
    condition     = can(regex("^[A-Z][a-z]+ [A-Z][a-z]+$", var.location))
    error_message = "Region must be in the format 'Region Name' with each word capitalized."
  }
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
