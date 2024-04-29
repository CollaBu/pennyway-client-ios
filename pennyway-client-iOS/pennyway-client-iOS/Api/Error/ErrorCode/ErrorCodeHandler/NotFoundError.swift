
func notFoundError(_ code: String, message: String) -> StatusSpecificError? {
    guard let notFoundError = NotFoundErrorCode(rawValue: code) else {
        return nil
    }
    let defaultMessage: String

    switch notFoundError {
    case .resourceNotFound:
        defaultMessage = "Requested resource not found"
    case .invalidURLOrEndpoint:
        defaultMessage = "Invalid URL or endpoint"
    case .resourceDeletedOrMoved:
        defaultMessage = "Resource deleted or moved"
    }

    return StatusSpecificError(domainError: .notFound, code: code, message: message.isEmpty ? defaultMessage : message)
}
