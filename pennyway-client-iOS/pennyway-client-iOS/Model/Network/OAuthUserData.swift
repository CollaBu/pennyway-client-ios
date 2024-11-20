// MARK: - OAuthUserData

struct OAuthUserData: Codable {
    var oauthId: String
    var idToken: String
    var nonce: String
    var deviceId: String
}

// MARK: - Provider

enum Provider: String {
    case kakao
    case google
    case apple
}
