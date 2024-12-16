variable "location" {
  type        = string
  description = "Location of the resource group and resources"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "environment" {
  type        = string
  description = "Environment"
} 

variable "tags" {
  description = "A map of tags to be applied to all resources"
  type        = map(string)
}
