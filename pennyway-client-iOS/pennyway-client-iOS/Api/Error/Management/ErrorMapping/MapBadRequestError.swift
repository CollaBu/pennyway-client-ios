
func mapBadRequestError(_ code: String, message: String) -> DomainSpecificError? {
    guard let badRequestError = BadRequestError(rawValue: code) else {
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
    }
    return DomainSpecificError(domainError: .badRequest, code: code, message: message.isEmpty ? defaultMessage : message)
}
