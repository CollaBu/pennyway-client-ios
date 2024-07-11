
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
    @Published var dailyDetailSpendings: [IndividualSpending] = [] // 지출내역 리스트 임시 데이터
    
//    IndividualSpending(id: 0, amount: 10000, category: SpendingCategory(isCustom: false, id: 0, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 1, amount: 10000, category: SpendingCategory(isCustom: false, id: 1, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 2, amount: 10000, category: SpendingCategory(isCustom: false, id: 2, name: "식비", icon: "FOOD"), spendAt: "2024-07-04", accountName: "abc", memo: "그냥"), IndividualSpending(id: 3, amount: 30000, category: SpendingCategory(isCustom: false, id: 3, name: "식비", icon: "TRAVEL"), spendAt: "2024-07-02", accountName: "abc", memo: "그냥"), IndividualSpending(id: 4, amount: 40000, category: SpendingCategory(isCustom: false, id: 4, name: "여행", icon: "TRAVEL"), spendAt: "2024-07-02", accountName: "abc", memo: "몰라")]
    
    @Published var spedingHistoryTotalCount = 0 // 지출 내역 리스트 총 개수
    @Published var currentPageNumber: Int = 0
    @Published var hasNext: Bool = true
    
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
    
    func getCategorySpendingCountApi(completion: @escaping (Bool) -> Void) {
        let getCategorySpendingCountRequestDto = GetCategorySpendingCountRequestDto(type: selectedCategory?.isCustom ?? false ? "CUSTOM" : "DEFAULT")
        
        let categoryId = selectedCategory!.id < 0 ? abs(selectedCategory!.id) : selectedCategory!.id
        
        SpendingCategoryAlamofire.shared.getCategorySpendingCount(categoryId, getCategorySpendingCountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(getCategorySpendingCountResponseDto.self, from: responseData)
                        
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("카테고리에 등록된 지출내역 총 개수 조회 \(jsonString)")
                        }
                        
                        self.spedingHistoryTotalCount = response.data.totalCount
        
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
    
    func getCategorySpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        guard hasNext else {
            return
        }
        
        let getCategorySpendingHistoryRequestDto = GetCategorySpendingHistoryRequestDto(type: "\(selectedCategory?.isCustom ?? false ? "CUSTOM" : "DEFAULT")", size: "5", page: "\(currentPageNumber)", sort: "spending.spendAt", direction: "DESC")
        
        let categoryId = selectedCategory!.id < 0 ? abs(selectedCategory!.id) : selectedCategory!.id
        
        SpendingCategoryAlamofire.shared.getCategorySpendingHistory(categoryId, getCategorySpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(getCategorySpendingHistoryResponseDto.self, from: responseData)
                        
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("카테고리에 등록된 지출내역 조회\(jsonString)")
                        }
                    
                        self.mergeNewSpendings(newSpendings: response.data.spendings.content)
                        self.currentPageNumber += 1
                        self.hasNext = response.data.spendings.hasNext
        
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
    
    private func mergeNewSpendings(newSpendings: [Spending]) {
        var allNewIndividualSpendings: [IndividualSpending] = []

        for newSpending in newSpendings {
            for newDailySpending in newSpending.dailySpendings {
                allNewIndividualSpendings.append(contentsOf: newDailySpending.individuals)
            }
        }

        let existingIds = Set(dailyDetailSpendings.map { $0.id })
        let uniqueNewSpendings = allNewIndividualSpendings.filter { !existingIds.contains($0.id) }
        
        dailyDetailSpendings.append(contentsOf: uniqueNewSpendings)
        dailyDetailSpendings.sort { $0.spendAt > $1.spendAt }
    }
    
    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.detailsWhite.icon)
    }
}
