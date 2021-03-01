variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "default"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-1"
}

variable "ec2_ssh_key_name" {
  description = "The SSH Key Name"
  type        = string
  default     = "platform-ec2-key"
}

variable "ec2_ssh_public_key_path" {
  description = "The local path to the SSH Public Key"
  type        = string
  default     = "./provision/access/deployment-ec2-key.pub"
}

variable "ec2_ssh_private_key_path" {
  description = "The local path to the SSH Private Key"
  type        = string
  default     = "./provision/access/deployment-ec2-key"
}
