# modules/instance_scheduler/main.tf

resource "aws_lambda_function" "instance_scheduler" {
  filename         = "${path.module}/lambda_function.zip"
  function_name    = "instance_scheduler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")
  timeout          = 10

  environment {
    variables = {
      INSTANCE_ID = var.instance_id
    }
  }
}

resource "aws_cloudwatch_event_rule" "instance_scheduler" {
  name                = "instance_scheduler"
  description         = "Schedule EC2 instance daily at 05:00 and 11:00 KST"
  schedule_expression = "cron(0,20 6 * * ? *)" # UTC 시간으로 20:00 (KST 05:00)와 02:00 (KST 11:00) cron(0 20,2 * * ? *) 기존값 
}

resource "aws_cloudwatch_event_target" "instance_scheduler" {
  rule      = aws_cloudwatch_event_rule.instance_scheduler.name
  target_id = "instance_scheduler"
  arn       = aws_lambda_function.instance_scheduler.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.instance_scheduler.arn
}

resource "aws_iam_role" "lambda_role" {
  name = "instance_scheduler_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "ec2_access" {
  name = "ec2_access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}