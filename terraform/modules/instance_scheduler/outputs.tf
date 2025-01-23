# modules/instance_scheduler/outputs.tf
output "lambda_function_arn" {
  value       = aws_lambda_function.instance_scheduler.arn
  description = "ARN of the Lambda function"
}

output "scheduler_rule_arn" {
  value       = aws_cloudwatch_event_rule.instance_scheduler.arn
  description = "ARN of the EventBridge rule for scheduling the instance"
}