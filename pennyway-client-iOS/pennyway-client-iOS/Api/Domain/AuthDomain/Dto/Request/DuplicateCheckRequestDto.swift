

public struct DuplicateCheckRequestDto: Encodable {
    let username: String

    public init(
        username: String
    ) {
        self.username = username
    }
}
