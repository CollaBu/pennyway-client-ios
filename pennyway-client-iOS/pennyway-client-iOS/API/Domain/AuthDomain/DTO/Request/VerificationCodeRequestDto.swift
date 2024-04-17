
public struct VerificationCodeRequestDto: Encodable {
    let phone: String

    public init(
        phone: String
    ) {
        self.phone = phone
    }
}
