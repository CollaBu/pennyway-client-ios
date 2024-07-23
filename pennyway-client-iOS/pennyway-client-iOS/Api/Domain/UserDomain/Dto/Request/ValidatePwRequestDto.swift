
public struct ValidatePwRequestDto: Encodable {
    let password: String

    public init(
        password: String
    ) {
        self.password = password
    }
}
