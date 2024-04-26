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

    private static func mapBadRequestError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let badRequestError = BadRequestError(rawValue: code) else {
            return nil
        }
        let defaultMessage: String

        switch badRequestError {
        case .invalidRequestSyntax:
            defaultMessage = "Invalid request syntax"
        case .missingRequiredParameter:
            defaultMessage = "Missing required parameter"
        case .malformedParameter:
            defaultMessage = "Malformed parameter"
        case .malformedRequestBody:
            defaultMessage = "Malformed request body"
        case .invalidRequest:
            defaultMessage = "Invalid Request"
        }
        return ErrorWithDomainErrorAndMessage(domainError: .badRequest, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapUnauthorizedError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let unauthorizedError = UnauthorizedError(rawValue: code) else {
            return nil
        }
        let defaultMessage: String

        switch unauthorizedError {
        case .missingOrInvalidCredentials:
            defaultMessage = "Missing or invalid credentials"
        case .expiredOrRevokedToken:
            defaultMessage = "Expired or revoked token"
        case .insufficientPermissions:
            defaultMessage = "Insufficient permissions"
        case .tamperedOrMalformedToken:
            defaultMessage = "Tampered or malformed token"
        }
        return ErrorWithDomainErrorAndMessage(domainError: .unauthorized, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapForbiddenError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let forbiddenError = ForbiddenError(rawValue: code) else {
            return nil
        }
        let defaultMessage: String

        switch forbiddenError {
        case .accessForbidden:
            defaultMessage = "Access to the requested resource is forbidden"
        case .ipAddressBlocked:
            defaultMessage = "IP address blocked"
        case .userAccountSuspendedOrBanned:
            defaultMessage = "User account suspended or banned"
        case .accessNotAllowedForUserRole:
            defaultMessage = "Access to resource not allowed for user role"
        }
        return ErrorWithDomainErrorAndMessage(domainError: .forbidden, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapNotFoundError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let notFoundError = NotFoundError(rawValue: code) else {
            return nil
        }
        let defaultMessage: String

        switch notFoundError {
        case .resourceNotFound:
            defaultMessage = "Requested resource not found"
        case .invalidURLOrEndpoint:
            defaultMessage = "Invalid URL or endpoint"
        case .resourceDeletedOrMoved:
            defaultMessage = "Resource deleted or moved"
        }
        
        return ErrorWithDomainErrorAndMessage(domainError: .notFound, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapMethodNotAllowedError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let methodNotAllowedError = MethodNotAllowedError(rawValue: code) else {
            return nil
        }

        var defaultMessage: String
        
        switch methodNotAllowedError {
        case .methodNotSupported:
            defaultMessage = "Request method not supported"
        case .unsupportedMethodAccess:
            defaultMessage = "Attempted to access unsupported method"
        }
        
        return ErrorWithDomainErrorAndMessage(domainError: .methodNotAllowed, code: code, message: message.isEmpty ? defaultMessage : message)
    }

    private static func mapNotAcceptableError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let notAcceptableError = NotAcceptableError(rawValue: code) else {
            return nil
        }
        
        let defaultMessage = "Requested resource format not supported"
     
        return ErrorWithDomainErrorAndMessage(domainError: .notAcceptable, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapConflictError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let conflictError = ConflictError(rawValue: code) else {
            return nil
        }
        
        var defaultMessage: String
        
        switch conflictError {
        case .requestConflictWithResourceState:
            defaultMessage = "Request conflicts with current state of resource"
        case .resourceAlreadyExists:
            defaultMessage = "Resource already exists"
        case .concurrentModificationConflict:
            defaultMessage = "Concurrent modification conflict"
        }
        
        return ErrorWithDomainErrorAndMessage(domainError: .conflict, code: code, message: message.isEmpty ? defaultMessage : message)
    }
    
    private static func mapPreconditionFailedError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let preconditionFailedError = PreconditionFailedError(rawValue: code) else {
            return nil
        }
        
        var defaultMessage: String
        
        switch preconditionFailedError {
        case .preconditionRequestHeaderNotMatched:
            defaultMessage = "Preconditions request header not matched"
        case .ifMatchOrIfNoneMatchHeadersNotMatched:
            defaultMessage = "If-Match or If-None-Match headers not matched"
        }
        
        return ErrorWithDomainErrorAndMessage(domainError: .preconditionFailed, code: code, message: message.isEmpty ? defaultMessage : message)
    }

    private static func mapUnprocessableContentError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        guard let unprocessableContentError = UnprocessableContentError(rawValue: code) else {
            return nil
        }
        
        var defaultMessage: String
        
        switch unprocessableContentError {
        case .requiredParametersMissingInRequestBody:
            defaultMessage = "Required parameters missing in request body"
        case .validationErrorsInRequestData:
            defaultMessage = "Validation errors in request data"
        case .typeMismatchErrorInRequestBody:
            defaultMessage = "Type mismatch error in request body"
        }
        
        return ErrorWithDomainErrorAndMessage(domainError: .unprocessableContent, code: code, message: message.isEmpty ? defaultMessage : message)
    }

    private static func mapInternalServerError(_ code: String, message: String) -> ErrorWithDomainErrorAndMessage? {
        
        guard let internalServerError = InternalServerError(rawValue: code) else {
            return nil
        }
        
        let defaultMessage = "Unexpected Error"
        
        return ErrorWithDomainErrorAndMessage(domainError: .internalServerError, code: code, message: message.isEmpty ? defaultMessage : message)
    }
}
