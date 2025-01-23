// variables.tf

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-2"
}

variable "ami" {
  type        = string
  description = "EC2 AMI ID"
}

variable "instance_type" {
  type        = string
  description = "인스턴스 유형"
}

variable "key_name" {
  type        = string
  description = "EC2 인스턴스에 연결할 키 페어 이름"
}

variable "availability_zone" {
  type        = string
  description = "인스턴스의 가용 영역"
  default     = "ap-northeast-2a"
}

variable "existing_security_group_id" {
  type        = string
  description = "기존 보안 그룹의 ID"
}

variable "existing_volume_id" {
  type        = string
  description = "ID of the existing EBS volume to attach"
}

variable "env_variables" {
  type = map(string)
  sensitive = true
  description = "Environment variables for .env file"
}

variable "git_repository_url" {
  type        = string
  description = "Git repository URL to clone"
}