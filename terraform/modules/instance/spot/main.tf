// modules/instance/spot/main.tf

# EC2 스팟 인스턴스 요청
resource "aws_spot_instance_request" "spot_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  wait_for_fulfillment   = true
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }

  spot_type = "one-time"
  tags = {
    Name = "SpotInstance"
  }

  user_data = var.user_data
}

# EBS 데이터 볼륨을 인스턴스에 연결
resource "aws_volume_attachment" "attach_data_volume" {
  device_name  = "/dev/sdf"
  volume_id    = var.volume_id
  instance_id  = aws_spot_instance_request.spot_instance.spot_instance_id
  force_detach = true
}