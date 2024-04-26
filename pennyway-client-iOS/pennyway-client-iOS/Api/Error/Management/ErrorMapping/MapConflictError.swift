
func mapConflictError(_ code: String, message: String) -> DomainSpecificError? {
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
    
    return DomainSpecificError(domainError: .conflict, code: code, message: message.isEmpty ? defaultMessage : message)
}
