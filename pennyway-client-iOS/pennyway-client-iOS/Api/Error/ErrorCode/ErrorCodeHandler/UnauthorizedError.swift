
func unauthorizedError(_ code: String, message: String) -> StatusSpecificError? {
    guard let unauthorizedError = UnauthorizedErrorCode(rawValue: code) else {
        return nil
    }
    let defaultMessage: String
    let fieldErrors: ErrorResponseData? = nil

    switch unauthorizedError {
    case .missingOrInvalidCredentials:
        defaultMessage = "Missing or invalid credentials"
    case .expiredOrRevokedToken:
        defaultMessage = "Expired or revoked token"
    case .insufficientPermissions:
        defaultMessage = "Insufficient permissions"
    case .tamperedOrMalformedToken:
        defaultMessage = "Tampered or malformed token"
    case .withoutOwnership:
        defaultMessage = "Without Ownership"
    }
    return StatusSpecificError(domainError: .unauthorized, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
