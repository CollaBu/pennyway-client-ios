

struct GetTargetAmountForPreviousMonthResponseDto: Codable {
    let code: String
    let data: AmountDetailData
    
    struct AmountDetailData: Codable {
        let targetAmount: PreviousTargetAmount
    }
    
}
// MARK: - TargetAmount

struct PreviousTargetAmount: Codable {
    let isPresent: Bool
    let amount: Int
}
