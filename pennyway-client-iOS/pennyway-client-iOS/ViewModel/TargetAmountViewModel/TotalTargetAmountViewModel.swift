

import SwiftUI

class TotalTargetAmountViewModel: ObservableObject {
    @Published var targetAmounts: [TargetAmountData] = []
    @Published var sortTargetAmounts: [TargetAmountData] = []
    @Published var currentData: TargetAmountData = TargetAmountData(year: 2024, month: 8, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 40000, diffAmount: 60000)

    init() {
        targetAmounts = [TargetAmountData(year: 2024, month: 8, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 40000, diffAmount: 60000), TargetAmountData(year: 2024, month: 7, targetAmount: TargetAmountData.Amount(id: 2, amount: 800_000), totalSpending: 900_000, diffAmount: -100_000), TargetAmountData(year: 2024, month: 6, targetAmount: TargetAmountData.Amount(id: 3, amount: 700_000), totalSpending: 700_000, diffAmount: 0), TargetAmountData(year: 2024, month: 5, targetAmount: TargetAmountData.Amount(id: 4, amount: 100_000), totalSpending: 50000, diffAmount: 50000), TargetAmountData(year: 2024, month: 4, targetAmount: TargetAmountData.Amount(id: 5, amount: 120_000), totalSpending: 60000, diffAmount: 60000), TargetAmountData(year: 2024, month: 3, targetAmount: TargetAmountData.Amount(id: 6, amount: 100_000), totalSpending: 150_000, diffAmount: -50000)]
        sortTargetAmounts = targetAmounts.sorted(by: { $0.month < $1.month })
    }
}
