
enum BadRequestErrorCode: String {
    case invalidRequestSyntax = "4000"
    case missingRequiredParameter = "4001"
    case malformedParameter = "4002"
    case malformedRequestBody = "4003"
    case invalidRequest = "4004"
}
