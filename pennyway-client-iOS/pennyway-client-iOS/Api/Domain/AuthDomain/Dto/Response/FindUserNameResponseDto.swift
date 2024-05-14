// MARK: - FindUserNameResponseDto

struct FindUserNameResponseDto: Codable {
    let code: String
    let data: FindUserNameResponseData
}

// MARK: - FindUserNameResponseData

struct FindUserNameResponseData: Codable {
    let user: FindUserNameResponseDatails
}

// MARK: - FindUserNameResponseDatails

struct FindUserNameResponseDatails: Codable {
    let username: String
}
