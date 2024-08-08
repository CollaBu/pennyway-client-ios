
import Foundation

struct UploadProfileImageResponseDto: Codable {
    let code: String
    let data: ProfileImageUrl

    struct ProfileImageUrl: Codable {
        let profileImageUrl: String
    }
}
