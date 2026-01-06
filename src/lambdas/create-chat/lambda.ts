import {APIGatewayProxyEvent} from "aws-lambda"
import {CreateChatResponse, HTTPResponse} from "../../shared/models"
import {DynamoDBClient} from "@aws-sdk/client-dynamodb"
import {DynamoDBDocumentClient, PutCommand, PutCommandOutput} from "@aws-sdk/lib-dynamodb"
import {v4 as UUID4} from "uuid"
const logger = console.log
const CHAT_TABLE_NAME: string = process.env.CHAT_TABLE_NAME
const dynamoDBClient: DynamoDBDocumentClient = DynamoDBDocumentClient.from(new DynamoDBClient())


const handler = async (event: APIGatewayProxyEvent): Promise<HTTPResponse> => {
    logger("Attempt made to create a new chat")

    const body: any = JSON.parse(event.body)
    const newChatId: string = UUID4()

    const dynamoDBDocumentClient: DynamoDBDocumentClient = DynamoDBDocumentClient.from(dynamoDBClient)
    const cmd: PutCommand = new PutCommand({
        TableName: CHAT_TABLE_NAME,
        Item: {
            chatId: newChatId,
            userId: body.userId || '007',
            name: body.name || 'Batman',
            timestamp: Date.now()
        },
        ReturnValues: "ALL_OLD"
    })

    let newItem: PutCommandOutput = await dynamoDBDocumentClient.send(cmd)
    const response: CreateChatResponse = newItem.Attributes as any
    const content: string = JSON.stringify(response)
    return {
        body: content,
        statusCode: 201,
        headers: {
            "content-type": "application/json",
            "x-chat-id": newChatId
        }
    }
}

export { handler }