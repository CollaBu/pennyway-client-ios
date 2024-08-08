
import Foundation

public struct UploadProfileImageRequestDto: Encodable {
    let profileImageUrl: String

    public init(
        profileImageUrl: String,
    ) {
        self.profileImageUrl = profileImageUrl
    }
}
