import {APIGatewayProxyEvent} from "aws-lambda"
import {HTTPResponse} from "../../shared/models"
const logger = console.log

export async function handler (event: APIGatewayProxyEvent): Promise<HTTPResponse> {
    logger("Attempt made to create a new chat")

    const content: string = JSON.stringify({ chatId: "007", timestamp: 1234567890 })
    return {
        body: content,
        statusCode: 201,
        headers: {
            "content-type": "application/json",
            "x-chat-id": 0.007
        }
    }
}