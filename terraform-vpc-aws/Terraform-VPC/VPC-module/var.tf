variable "cidr_block" {
    description = "The CIDR block for the VPC."
    type        = string
    default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    default     = true
}

variable "project_name" {
    default     = {}
}

variable "common_tags" {
    type       = map(string)
    default = {}
}

variable "environment" {
    default     = {}
}

variable "igw_tags" {
    default     = {}
}

variable "public_subnet_cidrs" {
    type       = list
    validation {
        condition     = length(var.public_subnet_cidrs) == 2
        error_message = "At least 2 public subnet CIDR must be provided."
    }
}

variable "public_subnet_tags"{
    default     = {}
}

variable "private_subnet_tags" {
    default = {}
}

variable "private_subnet_cidrs" {
    default = {}
}

variable "database_subnet_tags" {
    default = {}
}

variable "database_subnet_cidrs" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

variable "vpc_peering_tags" {
    default = {}
}

variable "is_peering_enabled" {
    default = false
}

variable "vpc_id" {
    default = {}
}