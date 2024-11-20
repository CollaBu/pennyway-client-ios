// MARK: - FcmTokenDto

public struct FcmTokenDto: Encodable {
    let token: String

    public init(
        token: String
    ) {
        self.token = token
    }
}

// MARK: - DeviceInfoDto

public struct DeviceInfoDto: Encodable {
    let token: String
    let deviceId: String
    let deviceName: String

    public init(
        token: String,
        deviceId: String,
        deviceName: String
    ) {
        self.token = token
        self.deviceId = deviceId
        self.deviceName = deviceName
    }
}
