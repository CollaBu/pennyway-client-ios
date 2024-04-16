
public struct OAuthVerificationCodeRequestDTO: Encodable {
    let phone: String
    let provider: String

    public init(
        phone: String,
        provider: String
    ) {
        self.phone = phone
        self.provider = provider
    }
}
