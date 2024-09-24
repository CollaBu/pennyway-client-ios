
import Foundation
import UIKit

// MARK: - UserProfileItemModel

struct UserProfileItemModel: Equatable {
    var username: String
    var name: String
    var profileImage: UIImage?
    var profileImageUrl: String

    mutating func imageDelete() {
        profileImage = nil
    }

    mutating func imageUpdate(image: UIImage) {
        profileImage = image
    }
}

extension UserProfileItemModel {
    init(userData: UserModel) {
        username = userData.username
        name = userData.name
        profileImageUrl = userData.profileImageUrl
    }
}
