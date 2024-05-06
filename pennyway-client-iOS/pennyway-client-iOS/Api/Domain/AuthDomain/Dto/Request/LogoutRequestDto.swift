

public struct LogoutRequestDto: Encodable {
    let accessToken: String
    let refreshToken: String

    public init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
