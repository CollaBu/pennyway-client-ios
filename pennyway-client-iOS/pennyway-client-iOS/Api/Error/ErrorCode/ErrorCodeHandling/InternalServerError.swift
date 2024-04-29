
func internalServerError(_ code: String, message: String) -> StatusSpecificError? {
    guard let internalServerError = InternalServerErrorCode(rawValue: code) else {
        return nil
    }
    
    let defaultMessage = "Unexpected Error"
    
    return StatusSpecificError(domainError: .internalServerError, code: code, message: message.isEmpty ? defaultMessage : message)
}
