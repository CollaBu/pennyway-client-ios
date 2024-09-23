
import Foundation

// MARK: - ProfileImageItemModel

struct ProfileImageItemModel: Equatable {
    var profileImageUrl: String
}

extension ProfileImageItemModel {
    init(userData: UserModel) {
        profileImageUrl = userData.profileImageUrl
    }
}
