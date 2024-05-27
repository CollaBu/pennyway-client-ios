
func internalServerError(_ code: String, message: String) -> StatusSpecificError? {
    guard let internalServerError = InternalServerErrorCode(rawValue: code) else {
        return nil
    }

    let defaultMessage = "Unexpected Error"
//    let fieldErrors = ErrorResponseData(field: internalServerError.rawValue)
    let fieldErrors: ErrorResponseData? = nil

    return StatusSpecificError(domainError: .internalServerError, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
