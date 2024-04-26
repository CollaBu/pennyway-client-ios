
func mapUnprocessableContentError(_ code: String, message: String) -> DomainSpecificError? {
    guard let unprocessableContentError = UnprocessableContentError(rawValue: code) else {
        return nil
    }
    
    var defaultMessage: String
    
    switch unprocessableContentError {
    case .requiredParametersMissingInRequestBody:
        defaultMessage = "Required parameters missing in request body"
    case .validationErrorsInRequestData:
        defaultMessage = "Validation errors in request data"
    case .typeMismatchErrorInRequestBody:
        defaultMessage = "Type mismatch error in request body"
    }
    
    return DomainSpecificError(domainError: .unprocessableContent, code: code, message: message.isEmpty ? defaultMessage : message)
}
