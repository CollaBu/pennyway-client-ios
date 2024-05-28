
func preconditionFailedError(_ code: String, message: String) -> StatusSpecificError? {
    guard let preconditionFailedError = PreconditionFailedErrorCode(rawValue: code) else {
        return nil
    }

    var defaultMessage: String
    let fieldErrors: ErrorResponseData? = nil

    switch preconditionFailedError {
    case .preconditionRequestHeaderNotMatched:
        defaultMessage = "Preconditions request header not matched"
    case .ifMatchOrIfNoneMatchHeadersNotMatched:
        defaultMessage = "If-Match or If-None-Match headers not matched"
    }

    return StatusSpecificError(domainError: .preconditionFailed, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
