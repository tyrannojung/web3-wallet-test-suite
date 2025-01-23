// modules/instance/spot/outputs.tf

output "instance_id" {
  value = aws_spot_instance_request.spot_instance.spot_instance_id
}