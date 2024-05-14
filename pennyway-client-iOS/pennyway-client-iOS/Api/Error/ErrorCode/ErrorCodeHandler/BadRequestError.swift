
func badRequestError(_ code: String, message: String) -> StatusSpecificError? {
    guard let badRequestError = BadRequestErrorCode(rawValue: code) else {
        return nil
    }
    let defaultMessage: String

    switch badRequestError {
    case .invalidRequestSyntax:
        defaultMessage = "Invalid request syntax"
    case .missingRequiredParameter:
        defaultMessage = "Missing required parameter"
    case .malformedParameter:
        defaultMessage = "Malformed parameter"
    case .malformedRequestBody:
        defaultMessage = "Malformed request body"
    case .invalidRequest:
        defaultMessage = "Invalid Request"
    case .clientError:
        defaultMessage = "Client Error"
    }
    return StatusSpecificError(domainError: .badRequest, code: code, message: message.isEmpty ? defaultMessage : message)
}
