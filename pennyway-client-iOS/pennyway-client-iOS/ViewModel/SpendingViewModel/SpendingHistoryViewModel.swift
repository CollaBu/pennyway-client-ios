
import SwiftUI

class SpendingHistoryViewModel: ObservableObject {
    @Published var currentDate: Date = Date() // 현재 날짜
    @Published var dailySpendings: [DailySpending] = [] // 데일리 지출 내역
    @Published var dailyDetailSpendings: [IndividualSpending] = [] // 데일리 지출 목록
    @Published var Spending: [Spending] = [] // 소비내역 

    @Published var isChangeMonth: Bool = false
    @Published var selectedDateToScroll: String? = nil

    @Published var selectedDateId = 0
    @Published var selectedDate: Date?

    @Published var spendingDetailViewUpdated: Bool = false
    @Published var spendingSheetViewUpdated: Bool = false

    @Published var isClickSpendingDetailView: Bool = false

    private var year: String {
        return String(Date.year(from: currentDate))
    }

    private var month: String {
        return String(Date.month(from: currentDate))
    }

    func updateCurrentDate(to date: Date) {
        currentDate = date
        selectedDate = nil
        fetchSpendingHistory()
    }

    private func fetchSpendingHistory() {
        checkSpendingHistoryApi { success in
            if success {
                Log.debug("소비내역 조회 api 연동 성공")
            } else {
                Log.debug("소비내역 조회 api 연동 실패")
            }
        }
    }

    /// 선택한 날짜에 해당하는 소비내역을 필터링
    func filteredSpendings(for date: Date?) -> [IndividualSpending] {
        guard let date = date else {
            return []
        }
        return dailyDetailSpendings.filter { spending in
            if let spendDate = DateFormatterUtil.dateFromString(spending.spendAt) {
                return Calendar.current.isDate(spendDate, inSameDayAs: date)
            }
            return false
        }
    }

    func getDailyTotalAmount(for date: Date) -> Int? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    /// 특정 ID에 해당하는 지출내역 검색
    func getSpendingDetail(by id: Int) -> IndividualSpending? {
        return dailyDetailSpendings.first { $0.id == id }
    }

    func checkSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: selectedDate ?? currentDate)

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

    func deleteSpendingHistory(spendingIds: [Int], completion: @escaping (Bool) -> Void) { // 지출내역 복수 삭제
        let dto = DeleteSpendingHistoryRequestDto(spendingIds: spendingIds)
        SpendingAlamofire.shared.deleteSpendingHistory(dto) { result in
            switch result {
            case .success:
                Log.debug("지출내역 복수 삭제 완료")
                self.dailyDetailSpendings.removeAll { spendingIds.contains($0.id) }
                completion(true)
            case let .failure(error):
                Log.error("지출내역 복수 삭제 실패: \(error)")
                completion(false)
            }
        }
    }

    func deleteSingleSpendingHistory(spendingId: Int, completion: @escaping (Bool) -> Void) { // 지출내역 단일 삭제
        SpendingAlamofire.shared.deleteSingleSpendingHistory(spendingId: spendingId) { result in
            switch result {
            case .success:
                Log.debug("지출내역 단일 삭제 완료")
                self.dailyDetailSpendings.removeAll { $0.id == spendingId }
                completion(true)
            case let .failure(error):
                Log.error("지출내역 단일 삭제 실패: \(error)")
                completion(false)
            }
        }
    }
}
