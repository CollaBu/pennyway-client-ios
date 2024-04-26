// MARK: - ErrorWithDomainErrorAndMessage

struct ErrorWithDomainErrorAndMessage: Error {
    let domainError: DomainError
    let code: String
    let message: String
}

// MARK: - ErrorCodeMapper

enum ErrorCodeMapper {
    static func mapError(_ statusCode: Int, code: String?, message: String?) -> ErrorWithDomainErrorAndMessage? {
        let defaultMessage: String = message ?? ""
        guard let errorCode = code else { return nil }
        switch statusCode {
        case 400:
            return mapBadRequestError(errorCode, message: defaultMessage)
        case 401:
            defaultMessage = "Unauthorized"
            return ErrorWithDomainErrorAndMessage(domainError: .unauthorized, code: code ?? "", message: message ?? defaultMessage)
        case 403:
            defaultMessage = "Forbidden"
            return ErrorWithDomainErrorAndMessage(domainError: .forbidden, code: code ?? "", message: message ?? defaultMessage)
        case 404:
            defaultMessage = "Not Found"
            return ErrorWithDomainErrorAndMessage(domainError: .notFound, code: code ?? "", message: message ?? defaultMessage)
        case 405:
            defaultMessage = "Method Not Allowed"
            return ErrorWithDomainErrorAndMessage(domainError: .methodNotAllowed, code: code ?? "", message: message ?? defaultMessage)
        case 406:
            defaultMessage = "Not Acceptable"
            return ErrorWithDomainErrorAndMessage(domainError: .notAcceptable, code: code ?? "", message: message ?? defaultMessage)
        case 409:
            defaultMessage = "Conflict"
            return ErrorWithDomainErrorAndMessage(domainError: .conflict, code: code ?? "", message: message ?? defaultMessage)
        case 412:
            defaultMessage = "Precondition Failed"
            return ErrorWithDomainErrorAndMessage(domainError: .preconditionFailed, code: code ?? "", message: message ?? defaultMessage)
        case 422:
            defaultMessage = "Unprocessable Content"
            return ErrorWithDomainErrorAndMessage(domainError: .unprocessableContent, code: code ?? "", message: message ?? defaultMessage)
        case 500:
            defaultMessage = "Internal Server Error"
            return ErrorWithDomainErrorAndMessage(domainError: .internalServerError, code: code ?? "", message: message ?? defaultMessage)
        default:
            return nil
        }
    }
    
    private static func mapBadRequestError(_ code: String, message: String) ->  ErrorWithDomainErrorAndMessage? {
        guard let badRequestError = BadRequestError(rawValue: code) else { return nil }
        let defaultMessage: String
        
        switch badRequestError {
        case .invalidRequestSyntax:
            defaultMessage = "Invalid request syntax"
            return ErrorWithDomainErrorAndMessage(domainError: .badRequest, code: code, message: message.isEmpty ? defaultMessage : message)
        case .missingRequiredParameter:
            return .badRequest(code: code, message: defaultMessage.isEmpty ? "Missing required parameter" : defaultMessage)
        case .malformedParameter:
            return .badRequest(code: code, message: defaultMessage.isEmpty ? "Malformed parameter" : defaultMessage)
        case .malformedRequestBody:
            return .badRequest(code: code, message: defaultMessage.isEmpty ? "Malformed request body" : defaultMessage)
        case .invalidRequest:
            return .badRequest(code: code, message: defaultMessage.isEmpty ? "Invalid Request" : defaultMessage)
        }
    }
}
