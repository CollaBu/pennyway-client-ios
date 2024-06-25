

import SwiftUI

class TargetAmountViewModel: ObservableObject {
    @Published var totalSpent = 0
    @Published var targetValue: CGFloat = 0

    func getTotalTargetAmountApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.getTargetAmountForDate { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForDateResponseDto.self, from: responseData)

                        let validTotalSpending = response.data.targetAmount // 현재 달의 총 지출 금액 찾기
                        self.totalSpent = validTotalSpending.totalSpending

//                        if validTotalSpending.targetAmount.id != -1 && validTotalSpending.targetAmount.amount != -1 {
//                            self.targetValue = CGFloat(validTotalSpending.targetAmount.amount)
//                            // TODO: -1인 경우 목표 금액이 없으므로, 목표 금액 설정하기 화면 보여주기
//                        }

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
