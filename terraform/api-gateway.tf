resource "aws_api_gateway_rest_api" "web_chat_rest_api" {
  name = "web-chat-rest-api"
  description = "REST API for Webchat"
  body = templatefile("${path.module}/chat-api-swagger.yaml", {
    CREATE_CHAT_LAMBDA_INVOKE_ARN = aws_lambda_function.create_chat_lambda.invoke_arn
  })

}