variable "internet_gateway_should_be_created" {
  description = "Should the Internet Gateway be created?"
  type        = bool
  default     = true
}

variable "internet_gateway_name" {
  description = "The Name of the Internet Gateway"
  type        = string
  default     = "Platform Project Internet Gateway"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
