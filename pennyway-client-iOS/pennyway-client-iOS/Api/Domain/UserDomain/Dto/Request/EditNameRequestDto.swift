
public struct EditNameRequestDto: Encodable {
    let name: String

    public init(
        name: String
    ) {
        self.name = name
    }
}
