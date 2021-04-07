variable "prefix" {
  type        = string
  description = "Main prefix for all objects"
}

variable "rg-name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location to deploy to"
  default     = "West Europe"
}

variable "sg-name" {
  type        = string
  description = "Name of the security group"
}

variable "ddos-plan-name" {
  type        = string
  description = "Name of the vnet ddos plan"
}

variable "vnet-name" {
  type        = string
  description = "Name of the vnet ddos plan"
}

variable "address-space" {
  type        = list
  description = "CIDR ranges for vnet"
  default     = ["10.0.0.0/16"]
}

variable "subnet1-name" {
  type        = string
  description = "Name of a single vnet subnet"
}

variable "subnet1-address-prefix" {
  type        = string
  description = "CIDR of single vnet subnet"
  default     = "10.0.1.0/24"
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for taggable resources."
  default     = {}
}
