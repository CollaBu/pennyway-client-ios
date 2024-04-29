
struct StatusSpecificError: Error {
    let domainError: StatusError
    let code: String
    let message: String
}
