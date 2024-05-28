

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    // 카테고리

    /// 카테고리 선택
    @Published var selectedCategory: (String, String)? = nil
    @Published var isCategoryListViewPresented: Bool = false

    /// 카테고리 생성
    @Published var selectedCategoryIcon: String? = nil
    @Published var categoryName: String = ""
    @Published var isAddCategoryFormValid = false
    @Published var navigateToAddCategory = false // 추가하기 버튼 누른 경우
    @Published var isSelectAddCategoryViewPresented: Bool = false

    /// 날짜 선택
    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()

    /// 가격, 소비처, 메모 text
    @Published var amountSpentText: String = ""
    @Published var consumerText: String = ""
    @Published var memoText: String = ""

    @Published var spendingCategories: [SpendingCategoryData] = []

    @Published var isFormValid = false // 지출내역 추가 valid

    func validateForm() {
        isFormValid = (selectedCategory != nil && !amountSpentText.isEmpty)
    }

    func getSpendingCustomCategoryListApi() {
        SpendingAlamofire.shared.getSpendingCustomCategoryList { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(getSpendingCustomCategoryListResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 정의 카테고리 조회 완료 \(jsonString)")
                        }
                        let staticCategories = SpendingCategoryIconList.allCases
                            .filter { $0 != .other }
                            .map { $0.details }

                        let otherCategory = SpendingCategoryIconList.other.details
                        let dynamicCategories = response.data.spendingCategories.compactMap { self.convertToSpendingCategoryData(from: $0) }
                        self.spendingCategories = staticCategories + dynamicCategories + [otherCategory]
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }

    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(icon: iconList.details.icon, name: spendingCategory.name)
    }
}
