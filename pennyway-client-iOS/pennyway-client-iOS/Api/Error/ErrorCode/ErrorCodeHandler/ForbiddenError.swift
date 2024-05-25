
func forbiddenError(_ code: String, message: String) -> StatusSpecificError? {
    guard let forbiddenError = ForbiddenErrorCode(rawValue: code) else {
        return nil
    }
    let defaultMessage: String
    let fieldErrors = ErrorResponseData(field: forbiddenError.rawValue)

    switch forbiddenError {
    case .accessForbidden:
        defaultMessage = "Access to the requested resource is forbidden"
    case .ipAddressBlocked:
        defaultMessage = "IP address blocked"
    case .userAccountSuspendedOrBanned:
        defaultMessage = "User account suspended or banned"
    case .accessNotAllowedForUserRole:
        defaultMessage = "Access to resource not allowed for user role"
    }
    return StatusSpecificError(domainError: .forbidden, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
