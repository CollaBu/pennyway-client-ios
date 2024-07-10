
import SwiftUI

class SpendingCategoryViewModel: ObservableObject {
    /// 카테고리 선택
    @Published var selectedCategory: SpendingCategoryData? = nil
    
    /// 총 카테고리 리스트
    @Published var spendingCategories: [SpendingCategoryData] = []
    
    /// 시스템 카테고리 리스트
    @Published var systemCategories: [SpendingCategoryData] = []
    
    /// 사용자 정의 카테고리 리스트
    @Published var customCategories: [SpendingCategoryData] = []
    @Published var dailyDetailSpendings: [IndividualSpending] = [IndividualSpending(id: 0, amount: 10000, category: SpendingCategory(isCustom: false, id: 0, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 1, amount: 10000, category: SpendingCategory(isCustom: false, id: 1, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 2, amount: 10000, category: SpendingCategory(isCustom: false, id: 2, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 3, amount: 30000, category: SpendingCategory(isCustom: false, id: 3, name: "식비", icon: "TRAVEL"), spendAt: "2024-07-02", accountName: "abc", memo: "그냥"), IndividualSpending(id: 4, amount: 40000, category: SpendingCategory(isCustom: false, id: 4, name: "여행", icon: "TRAVEL"), spendAt: "2024-07-02", accountName: "abc", memo: "몰라")] // 지출내역 리스트 임시 데이터
    
    func getSpendingCustomCategoryListApi(completion: @escaping (Bool) -> Void) {
        SpendingCategoryAlamofire.shared.getSpendingCustomCategoryList { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(getSpendingCustomCategoryListResponseDto.self, from: responseData)
                        
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 정의 카테고리 조회 완료 \(jsonString)")
                        }
                        self.systemCategories = SpendingCategoryIconList.allCases
                            .filter { $0 != .other && $0 != .plus }
                            .map { $0.detailsWhite } // 배경색 흰색인 데이터 가져오기
                        
                        let otherCategory = SpendingCategoryIconList.plus.details
                        self.customCategories = response.data.spendingCategories.compactMap { self.convertToSpendingCategoryData(from: $0) }
                        self.spendingCategories = self.systemCategories + self.customCategories + [otherCategory]
                        completion(true)
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
                completion(false)
            }
        }
    }
    
    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.detailsWhite.icon)
    }
}
