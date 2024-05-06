

public struct LinkOAuthToAccountRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let phone: String
    let code: String
    let provider: String

    public init(
        oauthId: String,
        idToken: String,
        phone: String,
        code: String,
        provider: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.phone = phone
        self.code = code
        self.provider = provider
    }
}
