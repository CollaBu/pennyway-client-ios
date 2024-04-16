

public struct SignUpRequestDTO: Encodable {
    let name: String
    let username: String
    let password: String
    let phone: String
    let code: String

    public init(
        name: String,
        username: String,
        password: String,
        phone: String,
        code: String
    ) {
        self.name = name
        self.username = username
        self.password = password
        self.phone = phone
        self.code = code
    }
}
