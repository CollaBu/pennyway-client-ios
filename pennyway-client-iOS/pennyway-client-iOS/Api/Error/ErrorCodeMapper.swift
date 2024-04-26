
enum ErrorCodeMapper {
    static func mapError(_ statusCode: Int, code: String?, message: String?) -> DomainSpecificError? {
        let defaultMessage: String = message ?? ""
        guard let errorCode = code else {
            return nil
        }
        switch statusCode {
        case 400:
            return mapBadRequestError(errorCode, message: defaultMessage)
        case 401:
            return mapUnauthorizedError(errorCode, message: defaultMessage)
        case 403:
            return mapForbiddenError(errorCode, message: defaultMessage)
        case 404:
            return mapNotFoundError(errorCode, message: defaultMessage)
        case 405:
            return mapMethodNotAllowedError(errorCode, message: defaultMessage)
        case 406:
            return mapNotAcceptableError(errorCode, message: defaultMessage)
        case 409:
            return mapConflictError(errorCode, message: defaultMessage)
        case 412:
            return mapPreconditionFailedError(errorCode, message: defaultMessage)
        case 422:
            return mapUnprocessableContentError(errorCode, message: defaultMessage)
        case 500:
            return mapInternalServerError(errorCode, message: defaultMessage)
        default:
            return nil
        }
    }
}
