

public struct LoginRequestDto: Encodable {
    let username: String
    let password: String
    let deviceId: String

    public init(
        username: String,
        password: String,
        deviceId: String
    ) {
        self.username = username
        self.password = password
        self.deviceId = deviceId
    }
}
