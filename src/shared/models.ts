export interface HTTPResponse {
    statusCode: number
    body: string,
    headers?: Record<string, any>
}