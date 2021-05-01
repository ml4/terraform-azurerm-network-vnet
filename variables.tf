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

variable "sg_name" {
  type        = string
  description = "Name of the security group"
}

variable "ddos_plan_name" {
  type        = string
  description = "Name of the vnet ddos plan"
}

variable "vnet_name" {
  type        = string
  description = "Name of the vnet ddos plan"
}

variable "subnet_address_spaces" {
  type        = list
  description = "CIDR ranges for vnet"
  default     = ["10.0.0.0/16"]
}

variable "private_subnet_name" {
  type        = string
  description = "Name of a single private vnet subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR of single private vnet subnet"
  default     = "10.0.1.0/24"
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for taggable resources."
  default     = {}
}
