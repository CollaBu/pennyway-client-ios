
func mapUnauthorizedError(_ code: String, message: String) -> DomainSpecificError? {
    guard let unauthorizedError = UnauthorizedError(rawValue: code) else {
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
    return DomainSpecificError(domainError: .unauthorized, code: code, message: message.isEmpty ? defaultMessage : message)
}
