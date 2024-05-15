
import SwiftUI

class SpendingHistoryViewModel: ObservableObject {
    
    func checkSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let checkSpendingHistoryRequestDto = CheckSpendingHistoryRequestDto(year: "", month: "")

        SpendingAlamofire.shared.checkSpendingHistory(checkSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(CheckSpendingHistoryResponseDto.self, from: responseData)
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("지출 내역 조회 완료 \(jsonString)")
                        }
                        completion(true)
                    } catch {
                        print("Error parsing response JSON: \(error)")
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
