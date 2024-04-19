

public struct OAuthLoginRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let provider: String

    public init(
        oauthId: String,
        idToken: String,
        provider: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.provider = provider
    }
}
