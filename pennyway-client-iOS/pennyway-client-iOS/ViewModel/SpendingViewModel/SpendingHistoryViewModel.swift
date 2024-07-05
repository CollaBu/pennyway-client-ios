
import SwiftUI

class SpendingHistoryViewModel: ObservableObject {
    @Published var currentDate: Date = Date() // 현재 날짜
    @Published var dailySpendings: [DailySpending] = [] // 데일리 지출 내역
    @Published var dailyDetailSpendings: [IndividualSpending] = [] // 데일리 지출 목록
    @Published var isChangeMonth: Bool = false
    @Published var selectedDateToScroll: String? = nil

    @Published var selectedDateId = 0
    @Published var selectedDate: Date?

    private var year: String {
        return String(Date.year(from: currentDate))
    }

    private var month: String {
        return String(Date.month(from: currentDate))
    }

    func getDailyTotalAmount(for date: Date) -> Int? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    func checkSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        let yearString = String(year)
        let monthString = String(month)

        let checkSpendingHistoryRequestDto = GetSpendingHistoryRequestDto(year: yearString, month: monthString)

        SpendingAlamofire.shared.getSpendingHistory(checkSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetSpendingHistoryResponseDto.self, from: responseData)

                        self.dailyDetailSpendings.removeAll()
                        self.dailySpendings = response.data.spending.dailySpendings

                        for i in 0 ..< self.dailySpendings.count {
                            self.dailyDetailSpendings += self.dailySpendings[i].individuals
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

    // 지출내역 삭제 api
    //    func deleteSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
    //        SpendingAlamofire.shared.deleteSpendingHistory(spendingId: spendingId) { result in
    //            switch result {
    //            case let .success(data):
    //                if let responseData = data {
    //                    if let jsonString = String(data: responseData, encoding: .utf8) {
    //                        Log.debug("지출내역 삭제: \(jsonString)")
    //                    }
    //
    //                }
    //            case let .failure(error):
    //                if let StatusSpecificError = error as? StatusSpecificError {
    //                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
    //                } else {
    //                    Log.error("Network request failed: \(error)")
    //                }
    //            }
    //        }
    //    }

    // 지출 내역 수정 api
//    func editCurrentMonthTargetAmountApi() {
//        let editCurrentMonthTargetAmountRequestDto = AddSpendingHistoryRequestDto(amount: recentTargetAmountData!.amount ?? 0)
//        
//        TargetAmountAlamofire.shared.editCurrentMonthTargetAmount(targetAmountId: targetAmountData?.targetAmountDetail.id ?? -1, dto: editCurrentMonthTargetAmountRequestDto) { result in
//            switch result {
//            case let .success(data):
//                if let responseData = data {
//                    if let jsonString = String(data: responseData, encoding: .utf8) {
//                        Log.debug("당월 목표 금액 수정 완료 \(jsonString)")
//                    }
//                    // 당월 목표 금액 조회 재요청
//                    self.getTargetAmountForDateApi { _ in }
//                }
//            case let .failure(error):
//                if let StatusSpecificError = error as? StatusSpecificError {
//                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
//                } else {
//                    Log.error("Network request failed: \(error)")
//                }
//            }
//        }
//    }
}
