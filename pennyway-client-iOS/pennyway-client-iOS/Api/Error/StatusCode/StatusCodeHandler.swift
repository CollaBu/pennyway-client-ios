
enum StatusCodeHandler {
    static func handleStatusCode(_ statusCode: Int, code: String?, message: String?) -> StatusSpecificError? {
        let defaultMessage: String = message ?? ""
        guard let errorCode = code else {
            return nil
        }
        switch statusCode {
        case 400:
            return badRequestError(errorCode, message: defaultMessage)
        case 401:
            return unauthorizedError(errorCode, message: defaultMessage)
        case 403:
            return forbiddenError(errorCode, message: defaultMessage)
        case 404:
            return notFoundError(errorCode, message: defaultMessage)
        case 405:
            return methodNotAllowedError(errorCode, message: defaultMessage)
        case 406:
            return notAcceptableError(errorCode, message: defaultMessage)
        case 409:
            return conflictError(errorCode, message: defaultMessage)
        case 412:
            return preconditionFailedError(errorCode, message: defaultMessage)
        case 422:
            return unprocessableContentError(errorCode, message: defaultMessage)
        case 429:
            return tooManyRequestError(errorCode, message: defaultMessage)
        case 500:
            return internalServerError(errorCode, message: defaultMessage)
        default:
            return nil
        }
    }
}
