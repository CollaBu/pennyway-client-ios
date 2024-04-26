
func mapPreconditionFailedError(_ code: String, message: String) -> DomainSpecificError? {
    guard let preconditionFailedError = PreconditionFailedError(rawValue: code) else {
        return nil
    }
    
    var defaultMessage: String
    
    switch preconditionFailedError {
    case .preconditionRequestHeaderNotMatched:
        defaultMessage = "Preconditions request header not matched"
    case .ifMatchOrIfNoneMatchHeadersNotMatched:
        defaultMessage = "If-Match or If-None-Match headers not matched"
    }
    
    return DomainSpecificError(domainError: .preconditionFailed, code: code, message: message.isEmpty ? defaultMessage : message)
}
