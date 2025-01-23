// modules/network/variables.tf

variable "vpc_id" {
  description = "VPC ID to associate with the security group"
  type        = string
}

variable "ssh_access_ip" {
  description = "IP address that can SSH into the instance (CIDR format)"
  type        = string
}
