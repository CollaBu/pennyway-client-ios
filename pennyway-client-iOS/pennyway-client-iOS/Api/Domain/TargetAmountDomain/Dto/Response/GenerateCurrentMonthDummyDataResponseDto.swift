
// MARK: - CurrentMonthTargetAmountResponseDto


//generateCurrentMonthDummyData, editCurrentMonthTargetAmount 응답 포ㅁ
struct CurrentMonthTargetAmountResponseDto: Codable {
    let code: String
    let data: AmountDetailData
    
    struct AmountDetailData: Codable {
        let targetAmount: AmountDetail
    }
    
}
