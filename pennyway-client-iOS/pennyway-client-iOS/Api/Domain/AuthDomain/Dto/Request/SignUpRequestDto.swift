

public struct SignUpRequestDto: Encodable {
    let name: String
    let username: String
    let password: String
    let phone: String
    let code: String
    let deviceId: String

    public init(
        name: String,
        username: String,
        password: String,
        phone: String,
        code: String,
        deviceId: String
    ) {
        self.name = name
        self.username = username
        self.password = password
        self.phone = phone
        self.code = code
        self.deviceId = deviceId
    }

    static func from(model: SignUp) -> SignUpRequestDto {
        return SignUpRequestDto(name: model.name, username: model.username, password: model.password, phone: model.phone, code: model.code, deviceId: model.deviceId)
    }
}
