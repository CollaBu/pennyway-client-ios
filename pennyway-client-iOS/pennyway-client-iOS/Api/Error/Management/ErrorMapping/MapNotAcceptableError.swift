
func mapNotAcceptableError(_ code: String, message: String) -> DomainSpecificError? {
    guard let notAcceptableError = NotAcceptableError(rawValue: code) else {
        return nil
    }
    
    let defaultMessage = "Requested resource format not supported"
 
    return DomainSpecificError(domainError: .notAcceptable, code: code, message: message.isEmpty ? defaultMessage : message)
}
