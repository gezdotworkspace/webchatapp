resource "aws_lambda_function" "create_chat_lambda" {
  s3_bucket     = var.artifact_bucket_name
  s3_key        = "web-chat-app/create-chat/lambda.zip"
  function_name = "create_chat_lambda"
  role          = aws_iam_role.create_chat_role.arn
  handler       = "lambda.handler"
  runtime = "nodejs20.x"

  environment {
    variables = {
      CHAT_TABLE_NAME = aws_dynamodb_table.chat_table.name
      ENVIRONMENT = "dev"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "dev"
    App         = "web-chat-app"
  }
}

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_chat_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.web_chat_rest_api.execution_arn}/*"
}
