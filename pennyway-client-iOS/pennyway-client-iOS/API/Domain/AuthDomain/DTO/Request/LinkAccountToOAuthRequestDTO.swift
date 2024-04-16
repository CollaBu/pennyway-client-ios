

public struct LinkAccountToOAuthRequestDTO: Encodable {
    let password: String
    let phone: String
    let code: String

    public init(
        password: String,
        phone: String,
        code: String
    ) {
        self.password = password
        self.phone = phone
        self.code = code
    }
}
