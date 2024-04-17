
import Foundation

// MARK: - VerificationResponseDTO

struct VerificationResponseDTO: Codable {
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
}
