
func mapMethodNotAllowedError(_ code: String, message: String) -> DomainSpecificError? {
    guard let methodNotAllowedError = MethodNotAllowedError(rawValue: code) else {
        return nil
    }

    var defaultMessage: String

    switch methodNotAllowedError {
    case .methodNotSupported:
        defaultMessage = "Request method not supported"
    case .unsupportedMethodAccess:
        defaultMessage = "Attempted to access unsupported method"
    }

    return DomainSpecificError(domainError: .methodNotAllowed, code: code, message: message.isEmpty ? defaultMessage : message)
}
