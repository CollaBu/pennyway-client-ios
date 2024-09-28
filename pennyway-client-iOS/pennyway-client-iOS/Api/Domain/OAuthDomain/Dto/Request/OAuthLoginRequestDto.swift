

public struct OAuthLoginRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let provider: String

    public init(
        oauthId: String,
        idToken: String,
        nonce: String,
        provider: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.nonce = nonce
        self.provider = provider
    }

    static func from(model: OAuthLogin) -> OAuthLoginRequestDto {
        return OAuthLoginRequestDto.init(oauthId: model.oauthId, idToken: model.idToken, nonce: model.nonce, provider: model.provider)
    }
}
