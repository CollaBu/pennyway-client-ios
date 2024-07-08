
public struct FcmTokenDto: Encodable {
    let token: Int

    public init(
        token: Int
    ) {
        self.token = token
    }
}
