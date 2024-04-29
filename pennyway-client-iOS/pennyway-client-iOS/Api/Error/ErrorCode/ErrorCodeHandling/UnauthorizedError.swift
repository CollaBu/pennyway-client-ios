
func unauthorizedError(_ code: String, message: String) -> StatusSpecificError? {
    guard let unauthorizedError = UnauthorizedErrorCode(rawValue: code) else {
        return nil
    }
    let defaultMessage: String

    switch unauthorizedError {
    case .missingOrInvalidCredentials:
        defaultMessage = "Missing or invalid credentials"
    case .expiredOrRevokedToken:
        defaultMessage = "Expired or revoked token"
    case .insufficientPermissions:
        defaultMessage = "Insufficient permissions"
    case .tamperedOrMalformedToken:
        defaultMessage = "Tampered or malformed token"
    }
    return StatusSpecificError(domainError: .unauthorized, code: code, message: message.isEmpty ? defaultMessage : message)
}
