
enum StatusError: Error {
    case badRequest
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
