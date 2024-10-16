// MARK: - VerificationResponseDto

struct VerificationResponseDto: Codable {
    let code: String
    let data: VerificationResponseData
}

// MARK: - VerificationResponseData

struct VerificationResponseData: Codable {
    let sms: VerificationResponseDetails
}

// MARK: - VerificationResponseDetails

struct VerificationResponseDetails: Codable {
    let code: Bool
    let oauth: Bool
    let username: String?
}
