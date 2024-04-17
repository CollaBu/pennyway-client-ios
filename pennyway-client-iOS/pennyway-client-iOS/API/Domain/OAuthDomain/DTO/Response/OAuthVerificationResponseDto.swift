

import Foundation

// MARK: - OAuthVerificationResponseDto

struct OAuthVerificationResponseDto: Codable {
    let code: String
    let data: OAuthVerificationResponseData
}

// MARK: - OAuthVerificationResponseData

struct OAuthVerificationResponseData: Codable {
    let sms: OAuthVerificationResponseDetails
}

// MARK: - OAuthVerificationResponseDetails

struct OAuthVerificationResponseDetails: Codable {
    let code: Bool
    let existsUser: Bool
    let username: String
}
