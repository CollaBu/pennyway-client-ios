// MARK: - ErrorWithDomainErrorAndMessage

struct ErrorWithDomainErrorAndMessage: Error {
    let domainError: DomainError
    let message: String
}

// MARK: - ErrorCodeMapper

enum ErrorCodeMapper {
    static func mapError(_ statusCode: Int, code: String?, message: String?) -> ErrorWithDomainErrorAndMessage? {
        let defaultMessage: String
        switch statusCode {
        case 400:
            defaultMessage = "Bad Request"
            return ErrorWithDomainErrorAndMessage(domainError: .badRequest, message: message ?? defaultMessage)
        case 401:
            defaultMessage = "Unauthorized"
            return ErrorWithDomainErrorAndMessage(domainError: .unauthorized, message: message ?? defaultMessage)
        case 403:
            defaultMessage = "Forbidden"
            return ErrorWithDomainErrorAndMessage(domainError: .forbidden, message: message ?? defaultMessage)
        case 404:
            defaultMessage = "Not Found"
            return ErrorWithDomainErrorAndMessage(domainError: .notFound, message: message ?? defaultMessage)
        case 405:
            defaultMessage = "Method Not Allowed"
            return ErrorWithDomainErrorAndMessage(domainError: .methodNotAllowed, message: message ?? defaultMessage)
        case 406:
            defaultMessage = "Not Acceptable"
            return ErrorWithDomainErrorAndMessage(domainError: .notAcceptable, message: message ?? defaultMessage)
        case 409:
            defaultMessage = "Conflict"
            return ErrorWithDomainErrorAndMessage(domainError: .conflict, message: message ?? defaultMessage)
        case 412:
            defaultMessage = "Precondition Failed"
            return ErrorWithDomainErrorAndMessage(domainError: .preconditionFailed, message: message ?? defaultMessage)
        case 422:
            defaultMessage = "Unprocessable Content"
            return ErrorWithDomainErrorAndMessage(domainError: .unprocessableContent, message: message ?? defaultMessage)
        case 500:
            defaultMessage = "Internal Server Error"
            return ErrorWithDomainErrorAndMessage(domainError: .internalServerError, message: message ?? defaultMessage)
        default:
            return nil
        }
    }
}
