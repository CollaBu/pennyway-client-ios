

public struct LinkAccountToOAuthRequestDto: Encodable {
    let password: String
    let phone: String
    let code: String
    let deviceId: String

    public init(
        password: String,
        phone: String,
        code: String,
        deviceId: String
    ) {
        self.password = password
        self.phone = phone
        self.code = code
        self.deviceId = deviceId
    }

    static func from(model: LinkAccountToOAuth) -> LinkAccountToOAuthRequestDto {
        return LinkAccountToOAuthRequestDto(password: model.password, phone: model.phone, code: model.code, deviceId: model.deviceId)
    }
}
