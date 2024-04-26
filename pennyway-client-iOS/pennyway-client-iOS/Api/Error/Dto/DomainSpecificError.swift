
struct DomainSpecificError: Error {
    let domainError: DomainError
    let code: String
    let message: String
}
