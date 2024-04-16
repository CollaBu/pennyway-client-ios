

public struct LoginRequestDTO: Encodable {
    let username: String
    let password: String

    public init(
        username: String,
        password: String
    ) {
        self.username = username
        self.password = password
    }
}
