
func mapInternalServerError(_ code: String, message: String) -> DomainSpecificError? {
    guard let internalServerError = InternalServerError(rawValue: code) else {
        return nil
    }
    
    let defaultMessage = "Unexpected Error"
    
    return DomainSpecificError(domainError: .internalServerError, code: code, message: message.isEmpty ? defaultMessage : message)
}
