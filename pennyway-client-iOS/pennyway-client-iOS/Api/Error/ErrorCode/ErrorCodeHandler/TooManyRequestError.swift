
import Foundation

func tooManyRequestError(_ code: String, message: String) -> StatusSpecificError? {
    guard let tooManyRequestErrorCode = TooManyRequestErrorCode(rawValue: code) else {
        return nil
    }

    let defaultMessage = "TooManyRequest Error"
    let fieldErrors: ErrorResponseData? = nil

    return StatusSpecificError(domainError: .tooManyRequest, code: code, message: message.isEmpty ? defaultMessage : message, fieldErrors: fieldErrors)
}
