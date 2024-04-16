

public struct LinkOAuthToAccountRequestDTO: Encodable {
    let idToken: String
    let phone: String
    let code: String
    let provider: String

    public init(
        idToken: String,
        phone: String,
        code: String,
        provider: String
    ) {
        self.idToken = idToken
        self.phone = phone
        self.code = code
        self.provider = provider
    }
}
