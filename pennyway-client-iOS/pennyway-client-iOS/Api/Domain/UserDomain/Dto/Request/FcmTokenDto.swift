
public struct FcmTokenDto: Encodable {
    let token: String

    public init(
        token: String
    ) {
        self.token = token
    }
}
