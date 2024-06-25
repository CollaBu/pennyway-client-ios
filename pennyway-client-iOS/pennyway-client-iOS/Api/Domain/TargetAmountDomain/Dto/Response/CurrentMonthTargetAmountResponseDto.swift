// MARK: - CurrentMonthTargetAmountResponseDto

/// generateCurrentMonthDummyData, editCurrentMonthTargetAmount 응답 포멧
struct CurrentMonthTargetAmountResponseDto: Codable {
    let code: String
    let data: AmountDetailData

    struct AmountDetailData: Codable {
        let targetAmount: AmountDetail
    }
}
