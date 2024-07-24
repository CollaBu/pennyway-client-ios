
import SwiftUI

class SpendingCategoryViewModel: ObservableObject {
    /// 카테고리 선택
    @Published var selectedCategory: SpendingCategoryData? = nil
    @Published var categoryName = ""
    @Published var selectedCategoryIcon: CategoryIconName? = nil
    @Published var selectedCategoryIconTitle: String = ""
    
    /// 총 카테고리 리스트
    @Published var spendingCategories: [SpendingCategoryData] = []
    
    /// 시스템 카테고리 리스트
    @Published var systemCategories: [SpendingCategoryData] = []
    
    /// 사용자 정의 카테고리 리스트
    @Published var customCategories: [SpendingCategoryData] = []
    @Published var dailyDetailSpendings: [IndividualSpending] = [] // 지출내역 리스트 임시 데이터
    
    @Published var spedingHistoryTotalCount = 0 // 지출 내역 리스트 총 개수
    @Published var hasNext: Bool = true
    private var currentPageNumber: Int = 0
    
    /// 카테고리 조회 api 호출
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
    
    /// 카테고리 지출내역 개수 조회 api 호출
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
    
    /// 카테고리에 따른 지출내역 리스트 조회 api 호출
    func getCategorySpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        guard hasNext else {
            return
        }
        
        let getCategorySpendingHistoryRequestDto = GetCategorySpendingHistoryRequestDto(type: "\(selectedCategory?.isCustom ?? false ? "CUSTOM" : "DEFAULT")", size: "5", page: "\(currentPageNumber)")
        
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
    
    func initPage() {
        dailyDetailSpendings = []
        currentPageNumber = 0
        hasNext = true
    }
    
    /// 무한 스크롤 지출 데이터 merge
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
    
    /// white 배경색 아이콘 return
    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.detailsWhite.icon)
    }
    
    /// 카테고리 수정 api 호출
    func modifyCategoryApi(completion: @escaping (Bool) -> Void) {
        let modifyCategoryRequestDto = AddSpendingCustomCategoryRequestDto(name: categoryName, icon: selectedCategoryIconTitle)
        
        SpendingCategoryAlamofire.shared.modifyCategory(selectedCategory!.id, modifyCategoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("카테고리 수정 완료 \(jsonString)")
                    }
                    completion(true)
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
