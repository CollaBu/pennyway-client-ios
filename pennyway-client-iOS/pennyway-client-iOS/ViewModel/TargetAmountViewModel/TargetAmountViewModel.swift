

import SwiftUI

class TargetAmountViewModel: ObservableObject {
    @Published var totalSpent = 0
    @Published var targetValue: CGFloat = 0

    func getTotalTargetAmountApi(completion: @escaping (Bool) -> Void) {
        let getTotalTargetAmountRequestDto = GetTotalTargetAmountRequestDto(date: Date.getBasicformattedDate(from: Date()))

        TargetAmountAlamofire.shared.getTotalTargetAmount(getTotalTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTotalTargetAmountResponseDto.self, from: responseData)

                        let validTargetAmounts = response.data.targetAmounts.filter { $0.targetAmount.id != -1 && $0.targetAmount.amount != -1 }

                        if let firstValidTargetAmount = validTargetAmounts.first {
                            self.totalSpent = firstValidTargetAmount.totalSpending
                            self.targetValue = CGFloat(firstValidTargetAmount.targetAmount.amount)
                        } else {
                            Log.fault("No valid target amounts found")//TODO: 데이터가 없는 경우 처리 필요
                        }

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("지출 내역 조회 완료 \(jsonString)")
                        }
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}
