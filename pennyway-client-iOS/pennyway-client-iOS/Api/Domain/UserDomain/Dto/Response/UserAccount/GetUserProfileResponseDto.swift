// MARK: - GetUserProfileResponseDto

struct GetUserProfileResponseDto: Codable {
    let code: String
    let data: UserProfileData
}

// MARK: - UserProfileData

struct UserProfileData: Codable {
    let user: UserData
}

// MARK: - UserData

struct UserData: Codable {
    let id: Int
    let username: String
    let name: String
    let isGeneralSignUp: Bool
    let passwordUpdatedAt: String
    let profileImageUrl: String
    let phone: String
    let profileVisibility: String
    let locked: Bool
    let notifySetting: NotifySetting
    let createdAt: String
    let oauthAccount: OauthAccount
}

// MARK: - NotifySetting

struct NotifySetting: Codable {
    let accountBookNotify: Bool
    let feedNotify: Bool
    let chatNotify: Bool
}

// MARK: - OauthAccount

struct OauthAccount: Codable {
    let kakao: Bool
    let google: Bool
    let apple: Bool
}
