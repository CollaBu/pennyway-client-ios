

public struct OAuthLoginRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let provider: String
    let deviceId: String

    public init(
        oauthId: String,
        idToken: String,
        nonce: String,
        provider: String,
        deviceId: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.nonce = nonce
        self.provider = provider
        self.deviceId = deviceId
    }

    static func from(model: OAuthLogin) -> OAuthLoginRequestDto {
        return OAuthLoginRequestDto(oauthId: model.oauthId, idToken: model.idToken, nonce: model.nonce, provider: model.provider, deviceId: model.deviceId)
    }
}
