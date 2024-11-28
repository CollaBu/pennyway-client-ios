

public struct LinkOAuthToAccountRequestDto: Encodable {
    let oauthId: String
    let idToken: String
    let nonce: String
    let phone: String
    let code: String
    let provider: String
    let deviceId: String

    public init(
        oauthId: String,
        idToken: String,
        nonce: String,
        phone: String,
        code: String,
        provider: String,
        deviceId: String
    ) {
        self.oauthId = oauthId
        self.idToken = idToken
        self.nonce = nonce
        self.phone = phone
        self.code = code
        self.provider = provider
        self.deviceId = deviceId
    }

    static func from(model: LinkOAuthToAccount) -> LinkOAuthToAccountRequestDto {
        return LinkOAuthToAccountRequestDto(oauthId: model.oauthId, idToken: model.idToken, nonce: model.nonce, phone: model.phone, code: model.code, provider: model.provider, deviceId: model.deviceId)
    }
}
