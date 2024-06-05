
// MARK: - GenerateCurrentMonthDummyDataResponseDto

struct GenerateCurrentMonthDummyDataResponseDto: Codable {
    let code: String
    let data: AmountDetailData
    
    struct AmountDetailData: Codable {
        let targetAmount: AmountDetail
    }
    
}
