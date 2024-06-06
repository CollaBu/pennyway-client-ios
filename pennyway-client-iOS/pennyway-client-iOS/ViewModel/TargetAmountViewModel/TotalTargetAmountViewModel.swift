

import SwiftUI

// MARK: - TargetAmountData

/// 임시 데이터 모델 설정
struct TargetAmountData: Identifiable {
    let id = UUID()
    let year: Int
    let month: Int
    let targetAmount: Amount
    let totalSpending: Int
    let diffAmount: Int

    struct Amount: Codable {
        let id: Int
        let amount: Int
    }
}

// MARK: - TotalTargetAmountViewModel

class TotalTargetAmountViewModel: ObservableObject {
    @Published var targetAmounts: [TargetAmountData] = []
    @Published var sortTargetAmounts: [TargetAmountData] = []
    @Published var currentData: TargetAmountData

    init() {
        let initialTargetAmounts = [
            TargetAmountData(year: 2024, month: 6, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 40000, diffAmount: 60000),
            TargetAmountData(year: 2024, month: 5, targetAmount: TargetAmountData.Amount(id: 2, amount: 800_000), totalSpending: 900_000, diffAmount: -100_000),
            TargetAmountData(year: 2024, month: 4, targetAmount: TargetAmountData.Amount(id: 3, amount: 700_000), totalSpending: 700_000, diffAmount: 0),
            TargetAmountData(year: 2024, month: 3, targetAmount: TargetAmountData.Amount(id: 4, amount: 100_000), totalSpending: 50000, diffAmount: 50000),
            TargetAmountData(year: 2024, month: 2, targetAmount: TargetAmountData.Amount(id: 5, amount: 120_000), totalSpending: 60000, diffAmount: 60000),
            TargetAmountData(year: 2024, month: 1, targetAmount: TargetAmountData.Amount(id: 6, amount: 1_000_000), totalSpending: 5_000_000, diffAmount: -4_000_000),
            TargetAmountData(year: 2023, month: 12, targetAmount: TargetAmountData.Amount(id: 6, amount: 800_000), totalSpending: 1_000_000, diffAmount: -200_000)
        ]

        targetAmounts = initialTargetAmounts
        sortTargetAmounts = initialTargetAmounts.sorted(by: { $0.month < $1.month })
        currentData = initialTargetAmounts.first ?? TargetAmountData(year: 2024, month: 6, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 40000, diffAmount: 60000)
    }
}