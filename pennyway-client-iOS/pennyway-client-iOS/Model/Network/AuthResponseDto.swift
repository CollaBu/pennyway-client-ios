// MARK: - AuthResponseDto

struct AuthResponseDto: Codable {
    let code: String
    let data: AuthResponseData
}

// MARK: - AuthResponseData

struct AuthResponseData: Codable {
    let user: AuthUserData
}

// MARK: - AuthUserData

struct AuthUserData: Codable {
    let id: Int
}
