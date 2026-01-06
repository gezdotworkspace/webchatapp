resource "aws_lambda_function" "create_chat_lambda" {
  s3_bucket     = var.artifact_bucket_name
  s3_key        = "web-chat-app/create-chat/lambda.zip"
  function_name = "create_chat_lambda"
  role          = aws_iam_role.create_chat_role.arn
  handler       = "lambda.handler"

  runtime = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = "dev"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "dev"
    App         = "web-chat-app"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "create_chat_role" {
  name               = "create_chat_role_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_chat_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.web_chat_rest_api.execution_arn}/*"
}
