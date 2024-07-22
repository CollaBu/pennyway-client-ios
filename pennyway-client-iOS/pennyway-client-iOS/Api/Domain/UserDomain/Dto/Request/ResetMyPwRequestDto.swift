
public struct ResetMyPwRequestDto: Encodable {
    let oldPassword: String
    let newPassword: String

    public init(
        oldPassword: String,
        newPassword: String
    ) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }
}
