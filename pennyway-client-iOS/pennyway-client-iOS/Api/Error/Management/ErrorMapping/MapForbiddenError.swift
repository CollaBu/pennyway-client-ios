
func mapForbiddenError(_ code: String, message: String) -> DomainSpecificError? {
    guard let forbiddenError = ForbiddenError(rawValue: code) else {
        return nil
    }
    let defaultMessage: String

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
    return DomainSpecificError(domainError: .forbidden, code: code, message: message.isEmpty ? defaultMessage : message)
}
