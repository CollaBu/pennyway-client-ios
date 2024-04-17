// MARK: - SMSResponseDTO

struct SMSResponseDTO: Codable {
    let code: String
    let data: SMSData
}

// MARK: - SMSData

struct SMSData: Codable {
    let sms: SMSDetails
}

// MARK: - SMSDetails

struct SMSDetails: Codable {
    let to: String
    let sendAt: String
    let expiresAt: String
}
