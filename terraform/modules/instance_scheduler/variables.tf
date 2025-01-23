# modules/instance_scheduler/variables.tf
variable "instance_id" {
  type        = string
  description = "ID of the EC2 instance to schedule"
}

variable "region" {
  type        = string
  description = "AWS region"
}