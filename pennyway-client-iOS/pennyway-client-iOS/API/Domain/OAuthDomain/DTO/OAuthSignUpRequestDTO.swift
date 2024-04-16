

public struct OAuthSignUpRequestDTO: Encodable {
    let idToken: String
    let name: String
    let username: String
    let phone: String
    let code: String
    let provider: String

    public init(
        idToken: String,
        name: String,
        username: String,
        phone: String,
        code: String,
        provider: String
    ) {
        self.idToken = idToken
        self.name = name
        self.username = username
        self.phone = phone
        self.code = code
        self.provider = provider
    }
}
