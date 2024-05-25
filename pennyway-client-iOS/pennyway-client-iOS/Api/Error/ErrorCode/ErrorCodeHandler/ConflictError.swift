
func conflictError(_ code: String, message: String) -> StatusSpecificError? {
    guard let conflictError = ConflictErrorCode(rawValue: code) else {
        return nil
    }

    var defaultMessage: String
    let fieldErrors = ErrorResponseData(field: conflictError.rawValue)

    switch conflictError {
    case .requestConflictWithResourceState:
        defaultMessage = "Request conflicts with current state of resource"
    case .resourceAlreadyExists:
        defaultMessage = "Resource already exists"
    case .concurrentModificationConflict:
        defaultMessage = "Concurrent modification conflict"
    }

    return StatusSpecificError(domainError: .conflict, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
