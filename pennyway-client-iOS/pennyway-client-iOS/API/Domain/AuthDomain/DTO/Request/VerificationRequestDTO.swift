
public struct VerificationRequestDTO: Encodable {
    let phone: String
    let code: String

    public init(
        phone: String,
        code: String
    ) {
        self.phone = phone
        self.code = code
    }
}
