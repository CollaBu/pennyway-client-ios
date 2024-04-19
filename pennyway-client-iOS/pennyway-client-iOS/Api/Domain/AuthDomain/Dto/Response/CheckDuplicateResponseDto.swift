// MARK: - CheckDuplicateResponseDto

struct CheckDuplicateResponseDto: Codable {
    let code: String
    let data: CheckDuplicateResponseData
}

// MARK: - CheckDuplicateResponseData

struct CheckDuplicateResponseData: Codable {
    let isDuplicate: Bool
}
