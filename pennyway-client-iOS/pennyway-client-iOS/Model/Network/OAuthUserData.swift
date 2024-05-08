// MARK: - OAuthUserData

struct OAuthUserData: Codable {
    var oauthId: String
    var idToken: String
    var nonce: String
}

// MARK: - provider

enum provider: String {
    case kakao = "kakao"
    case google = "google"
    case apple = "apple"
}
