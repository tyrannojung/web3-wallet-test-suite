// modules/ebs/variables.tf

variable "volume_size" {
  type        = number
  description = "EBS 볼륨 크기"
}

variable "availability_zone" {
  type        = string
  description = "EBS 볼륨의 가용 영역"
}

