# EC2 인스턴스 생성
resource "aws_instance" "regular_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "RegularInstance"
  }

  user_data = var.user_data
}
