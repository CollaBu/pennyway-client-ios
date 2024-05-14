
func notAcceptableError(_ code: String, message: String) -> StatusSpecificError? {
    guard let notAcceptableError = NotAcceptableErrorCode(rawValue: code) else {
        return nil
    }
    
    let defaultMessage = "Requested resource format not supported"
 
    return StatusSpecificError(domainError: .notAcceptable, code: code, message: message.isEmpty ? defaultMessage : message)
}
