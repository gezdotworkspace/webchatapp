resource "aws_iam_role" "create_chat_role" {
  name               = "create_chat_role_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_chat_role.json
}

data "aws_iam_policy_document" "assume_chat_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "chat_lambda_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DescribeTable"
    ]
    resources = [
      aws_dynamodb_table.chat_table.arn
    ]
  }
}

resource "aws_iam_role_policy" "chat_lambda_inline_policy" {
  name   = "chat-lambda-dynamodb-logs"
  role   = aws_iam_role.create_chat_role.id
  policy = data.aws_iam_policy_document.chat_lambda_permissions.json
}

