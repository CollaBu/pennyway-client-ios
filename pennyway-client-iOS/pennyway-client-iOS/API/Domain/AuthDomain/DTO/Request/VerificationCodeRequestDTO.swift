
public struct VerificationCodeRequestDTO: Encodable {
    let phone: String

    public init(
        phone: String
    ) {
        self.phone = phone
    }
}
