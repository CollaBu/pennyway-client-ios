
enum DomainError: Error {
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case conflict
    case preconditionFailed
    case unprocessableContent
    case internalServerError
}
