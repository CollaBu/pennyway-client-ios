// MARK: - SmsResponseDto

struct SmsResponseDto: Codable {
    let code: String
    let data: SmsData
}

// MARK: - SmsData

struct SmsData: Codable {
    let sms: SmsDetails
}

// MARK: - SmsDetails

struct SmsDetails: Codable {
    let to: String
    let sendAt: String
    let expiresAt: String
}
