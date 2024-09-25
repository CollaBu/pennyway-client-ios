// MARK: - GetUserProfileResponseDto

struct GetUserProfileResponseDto: Codable {
    let code: String
    let data: UserProfileData
}

// MARK: - UserProfileData

struct UserProfileData: Codable {
    let user: UserDataDto
}

// MARK: - UserDataDto

struct UserDataDto: Codable {
    let id: Int64
    var username: String
    var name: String
    let isGeneralSignUp: Bool
    let passwordUpdatedAt: String?
    var profileImageUrl: String
    var phone: String
    let profileVisibility: String
    let locked: Bool
    var notifySetting: NotifySettingDto
    let createdAt: String
    var oauthAccount: OauthAccountDto
}

// MARK: - NotifySettingDto

struct NotifySettingDto: Codable {
    let accountBookNotify: Bool
    let feedNotify: Bool
    let chatNotify: Bool
}

// MARK: - OauthAccountDto

struct OauthAccountDto: Codable {
    let kakao: Bool
    let google: Bool
    let apple: Bool
}
