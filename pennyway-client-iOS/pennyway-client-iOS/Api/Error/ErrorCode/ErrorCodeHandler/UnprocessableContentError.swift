
func unprocessableContentError(_ code: String, message: String) -> StatusSpecificError? {
    guard let unprocessableContentError = UnprocessableContentErrorCode(rawValue: code) else {
        return nil
    }

    var defaultMessage: String

    let fieldErrors = ErrorResponseData(field: unprocessableContentError.rawValue)

    switch unprocessableContentError {
    case .requiredParametersMissingInRequestBody:
        defaultMessage = "Required parameters missing in request body"
    case .validationErrorsInRequestData:
        defaultMessage = "Validation errors in request data"
    case .typeMismatchErrorInRequestBody:
        defaultMessage = "Type mismatch error in request body"
    }

    return StatusSpecificError(domainError: .unprocessableContent, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
