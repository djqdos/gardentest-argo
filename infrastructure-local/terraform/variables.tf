
variable "resource_group_location" {
  type        = string
  default     = "UK South"
  description = "Location of the resource group"
}


variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name"
}


variable "resource_group_name" {
  type        = string
  default     = "rb-rsg"
  description = "Name of the Resource group"
}


variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}
