export interface HTTPResponse {
    statusCode: number
    body: string
    headers?: Record<string, any>
}

export interface CreateChatRequest {
    chatId: string
    userId: string
    name: string
}

export interface CreateChatResponse {

}