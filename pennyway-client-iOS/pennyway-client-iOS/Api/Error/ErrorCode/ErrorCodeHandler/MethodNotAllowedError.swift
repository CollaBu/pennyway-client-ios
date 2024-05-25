
func methodNotAllowedError(_ code: String, message: String) -> StatusSpecificError? {
    guard let methodNotAllowedError = MethodNotAllowedErrorCode(rawValue: code) else {
        return nil
    }

    var defaultMessage: String
    let fieldErrors = ErrorResponseData(field: methodNotAllowedError.rawValue)

    switch methodNotAllowedError {
    case .methodNotSupported:
        defaultMessage = "Request method not supported"
    case .unsupportedMethodAccess:
        defaultMessage = "Attempted to access unsupported method"
    }

    return StatusSpecificError(domainError: .methodNotAllowed, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
