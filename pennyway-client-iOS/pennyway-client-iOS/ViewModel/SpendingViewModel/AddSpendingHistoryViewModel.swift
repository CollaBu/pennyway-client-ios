

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    /// 카테고리 선택
    @Published var selectedCategory: SpendingCategoryData? = nil
    @Published var isCategoryListViewPresented: Bool = false

    /// 카테고리 생성
    @Published var selectedCategoryIconTitle: String = ""
    @Published var selectedCategoryIcon: CategoryIconName? = nil
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

    /// 총 카테고리 리스트
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
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.details.icon)
    }

    func addSpendingCustomCategoryApi(completion: @escaping (Bool) -> Void) {
        let addSpendingCustomCategoryRequestDto = AddSpendingCustomCategoryRequestDto(name: categoryName, icon: selectedCategoryIconTitle)

        SpendingAlamofire.shared.addSpendingCustomCategory(addSpendingCustomCategoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AddSpendingCustomCategoryResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("카테고리 생성 완료 \(jsonString)")
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

    func addSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let amount = Int(amountSpentText.replacingOccurrences(of: ",", with: "")) ?? 0
        var categoryId = -1
        let spendAt = Date.getBasicformattedDate(from: selectedDate)

        if selectedCategory?.isCustom == false { // isCustom false 인 경우 -> 정의된 카테고리
            if let category = SpendingCategoryIconList.fromIcon(CategoryIconName(rawValue: (selectedCategory?.icon)!.rawValue)!) {
                selectedCategoryIconTitle = category.rawValue
                categoryId = -1
            }
        } else { // 사용자 정의 카테고리
            selectedCategoryIconTitle = "OTHER"
            categoryId = selectedCategory?.id ?? 0
        }

        let addSpendingHistoryRequestDto = AddSpendingHistoryRequestDto(amount: amount, categoryId: categoryId, icon: selectedCategoryIconTitle, spendAt: spendAt, accountName: consumerText, memo: memoText)

        SpendingAlamofire.shared.addSpendingHistory(addSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        _ = try JSONDecoder().decode(AddSpendingHistoryResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("지출내역 추가 완료 \(jsonString)")
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
