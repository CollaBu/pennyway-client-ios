
import Foundation

// MARK: - ErrorResponseDto

struct ErrorResponseDto: Codable {
    let code: String
    let message: String?
    let fieldErrors: ErrorResponseData?
}

// MARK: - ErrorResponseData

struct ErrorResponseData: Codable {
    let field: String?
}
