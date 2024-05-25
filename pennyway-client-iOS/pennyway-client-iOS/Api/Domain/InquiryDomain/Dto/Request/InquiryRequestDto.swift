
import Foundation

public struct InquiryRequestDto: Encodable {
    let email: String
    let content: String
    let category: String

    public init(
        email: String,
        content: String,
        category: String
    ) {
        self.email = email
        self.content = content
        self.category = category
    }
}
