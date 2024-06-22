
// MARK: - GetTargetAmountForPreviousMonthResponseDto

struct GetTargetAmountForPreviousMonthResponseDto: Codable {
    let code: String
    let data: AmountDetailData

    struct AmountDetailData: Codable {
        let targetAmount: RecentTargetAmount
    }
}
