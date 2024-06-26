

import SwiftUI

//// MARK: - TargetAmountData
//
///// 임시 데이터 모델 설정
// struct TargetAmountData: Identifiable {
//    let id = UUID()
//    let year: Int
//    let month: Int
//    let targetAmount: Amount
//    let totalSpending: Int
//    let diffAmount: Int
//
//    struct Amount: Codable {
//        let id: Int
//        let amount: Int
//    }
// }

// MARK: - TotalTargetAmountViewModel

class TotalTargetAmountViewModel: ObservableObject {
    @Published var targetAmounts: [TargetAmount] = []
    @Published var sortTargetAmounts: [TargetAmount] = []
    @Published var currentData: TargetAmount = TargetAmount(year: 0, month: 0, targetAmountDetail: AmountDetail(id: -1, amount: -1, isRead: false), totalSpending: 0, diffAmount: 0)

    func getTotalTargetAmountApi(completion: @escaping (Bool) -> Void) {
        let getTotalTargetAmountRequestDto = GetTotalTargetAmountRequestDto(date: Date.getBasicformattedDate(from: Date()))

        TargetAmountAlamofire.shared.getTotalTargetAmount(getTotalTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTotalTargetAmountResponseDto.self, from: responseData)

                        self.targetAmounts = response.data.targetAmounts
                        self.sortTargetAmounts = self.targetAmounts.sorted(by: { $0.month < $1.month })
                        if let firstTargetAmount = self.targetAmounts.first {
                            self.currentData = firstTargetAmount
                        }
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("목표 금액 및 총 사용 금액 리스트 조회 완료 \(jsonString)")
                        }

                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}

// init() {
//    let initialTargetAmounts = [
//        TargetAmountData(year: 2024, month: 6, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 0, diffAmount: 100_000),
//        TargetAmountData(year: 2024, month: 5, targetAmount: TargetAmountData.Amount(id: 2, amount: 800_000), totalSpending: 900_000, diffAmount: -100_000),
//        TargetAmountData(year: 2024, month: 4, targetAmount: TargetAmountData.Amount(id: 3, amount: 700_000), totalSpending: 700_000, diffAmount: 0),
//        TargetAmountData(year: 2024, month: 3, targetAmount: TargetAmountData.Amount(id: 4, amount: 100_000), totalSpending: 50000, diffAmount: 50000),
//        TargetAmountData(year: 2024, month: 2, targetAmount: TargetAmountData.Amount(id: 5, amount: 120_000), totalSpending: 60000, diffAmount: 60000),
//        TargetAmountData(year: 2024, month: 1, targetAmount: TargetAmountData.Amount(id: 6, amount: 1_000_000), totalSpending: 5_000_000, diffAmount: -4_000_000),
//        TargetAmountData(year: 2023, month: 12, targetAmount: TargetAmountData.Amount(id: 6, amount: 800_000), totalSpending: 1_000_000, diffAmount: -200_000)
//    ]
//
//    targetAmounts = initialTargetAmounts
//    sortTargetAmounts = initialTargetAmounts.sorted(by: { $0.month < $1.month })
//    currentData = initialTargetAmounts.first ?? TargetAmountData(year: 2024, month: 6, targetAmount: TargetAmountData.Amount(id: 1, amount: 100_000), totalSpending: 0, diffAmount: 100_000)
// }
