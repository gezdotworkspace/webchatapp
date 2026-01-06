resource "aws_dynamodb_table" "chat_table" {
  name = "chats"
  billing_mode = "PAY_PER_REQUEST"

  hash_key       = "chatId"
  range_key      = "userId"

  attribute {
    name = "chatId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  tags = {
    Environment = "dev"
  }
}
