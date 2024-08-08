
public struct GetNotificationRequestDto: Encodable {
    let size: String
    let page: String

    public init(
        size: String,
        page: String
    ) {
        self.size = size
        self.page = page
    }
}
