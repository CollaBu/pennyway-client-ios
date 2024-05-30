
import SwiftUI

class SpendingHistoryViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var totalSpent = 100_000

    @Published var dailySpendings: [DailySpending] = [] // 데일리 지출 내역

    private var year: String {
        return String(Date.year(from: currentDate))
    }

    private var month: String {
        return String(Date.month(from: currentDate))
    }

    func checkSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let checkSpendingHistoryRequestDto = GetSpendingHistoryRequestDto(year: year, month: month)

        SpendingAlamofire.shared.getSpendingHistory(checkSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetSpendingHistoryResponseDto.self, from: responseData)

                        self.dailySpendings = response.data.spending.dailySpendings

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
