
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
                        self.systemCategories = SpendingCategoryIconList.allCases
                            .filter { $0 != .other && $0 != .plus }
                            .map { $0.detailsWhite }
                        
                        let otherCategory = SpendingCategoryIconList.plus.details
                        self.customCategories = response.data.spendingCategories.compactMap { self.convertToSpendingCategoryData(from: $0) }
                        self.spendingCategories = self.systemCategories + self.customCategories + [otherCategory]
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
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.detailsWhite.icon)
    }
}
