

public struct OAuthLoginRequestDTO: Encodable {
    let oauthID: String
    let idToken: String
    let provider: String

    public init(
        oauthID: String,
        idToken: String,
        provider: String
    ) {
        self.oauthID = oauthID
        self.idToken = idToken
        self.provider = provider
    }
}
