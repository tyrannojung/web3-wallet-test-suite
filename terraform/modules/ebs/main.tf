// modules/ebs/variables.tf

resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size

  tags = {
    Name = "MyEBSVolume"
  }

    # 인스턴스 종료 시 EBS 볼륨 삭제하지 않음
  lifecycle {
    prevent_destroy = true
  }
}

output "volume_id" {
  value = aws_ebs_volume.volume.id
}