
public struct GetNotificationRequestDto: Encodable {
    let size: String
    let page: String
//    let sort: [String]

    public init(
        size: String,
        page: String
//        sort: [String]
    ) {
        self.size = size
        self.page = page
//        self.sort = sort
    }
}
