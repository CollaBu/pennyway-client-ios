
import SwiftUI

class SpendingHistoryViewModel: ObservableObject {
    @Published var currentDate: Date = Date()

    func checkSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let checkSpendingHistoryRequestDto = GetSpendingHistoryRequestDto(year: String(Date.year(from: currentDate)), month: String(Date.month(from: currentDate)))

        SpendingAlamofire.shared.getSpendingHistory(checkSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
//                    if let jsonString = String(data: responseData, encoding: .utf8) {
//                        print("Response Data: \(jsonString)")
//                        // 성공적으로 데이터를 출력한 경우 completion을 호출하여 true 전달
//                        completion(true)
//                    } else {
//                        print("Failed to convert response data to string.")
//                        completion(false)
//                    }
                    do {
                        let response = try JSONDecoder().decode(GetSpendingHistoryResponseDto.self, from: responseData)
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
