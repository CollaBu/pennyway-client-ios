

public struct OAuthVerificationRequestDTO: Encodable {
    let phone: String
    let code: String
    let provider: String

    public init(
        phone: String,
        code: String,
        provider: String
    ) {
        self.phone = phone
        self.code = code
        self.provider = provider
    }
}
