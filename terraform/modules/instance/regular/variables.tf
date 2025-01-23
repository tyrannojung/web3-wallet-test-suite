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
}

variable "security_group_id" {
  type        = string
  description = "보안 그룹의 ID"
}

variable "user_data" {
  type        = string
  description = "인스턴스 시작 시 실행할 사용자 데이터 스크립트"
}
