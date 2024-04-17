// MARK: - DuplicateCheckResponseDto

struct DuplicateCheckResponseDto: Codable {
    let code: String
    let data: DuplicateCheckResponseData
}

// MARK: - DuplicateCheckResponseData

struct DuplicateCheckResponseData: Codable {
    let isDuplicate: Bool
}
