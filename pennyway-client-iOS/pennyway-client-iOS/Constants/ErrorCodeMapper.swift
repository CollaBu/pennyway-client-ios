
enum ErrorCodeMapper {
    static func mapError(_ statusCode: Int) -> DomainError? {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 406:
            return .notAcceptable
        case 409:
            return .conflict
        case 412:
            return .preconditionFailed
        case 422:
            return .unprocessableContent
        case 500:
            return .internalServerError
        default:
            return nil
        }
    }
}
