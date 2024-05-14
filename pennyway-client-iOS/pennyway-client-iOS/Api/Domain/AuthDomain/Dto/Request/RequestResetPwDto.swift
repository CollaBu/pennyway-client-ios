
public struct RequestResetPwDto: Encodable {
    let phone: String
    let code: String
    let newPassword: String

    public init(
        phone: String,
        code: String,
        newPassword: String
    ) {
        self.phone = phone
        self.code = code
        self.newPassword = newPassword
    }
}
