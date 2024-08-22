import Combine
import SwiftUI

class SpendingCategoryViewModel: ObservableObject {
    /// 카테고리 선택
    @Published var selectedCategory: SpendingCategoryData? = nil
    @Published var selectedMoveCategory: SpendingCategoryData? = nil
    @Published var categoryName = ""
    @Published var selectedCategoryIcon: CategoryIconName? = nil
    @Published var selectedCategoryIconTitle: String = ""
    
    /// 카테고리 리스트 데이터
    @Published var amount: Int? = nil
    @Published var categoryIcon: String? = nil
    @Published var memo: String? = nil
    @Published var accountName: String? = nil
    @Published var spendAt: Date? = nil
    
    /// 총 카테고리 리스트
    @Published var spendingCategories: [SpendingCategoryData] = []
    
    /// 시스템 카테고리 리스트
    @Published var systemCategories: [SpendingCategoryData] = []
    
    /// 사용자 정의 카테고리 리스트
    @Published var customCategories: [SpendingCategoryData] = []
    @Published var dailyDetailSpendings: [IndividualSpending] = [] // 지출내역 리스트 임시 데이터
    @Published var selectSpending: IndividualSpending? = nil
    
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
        guard selectedCategory != nil else {
            return 
        }
        
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
    func getCategorySpendingHistoryApi(isReload: Bool? = false, completion: @escaping (Bool) -> Void) {
        guard hasNext, selectedCategory != nil else {
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                            self.dailyDetailSpendings.removeAll { $0.category.id != self.selectedCategory!.id }
                            self.mergeNewSpendings(newSpendings: response.data.spendings.content)
                            self.hasNext = response.data.spendings.hasNext
                            
                            if !(isReload ?? false) {
                                self.currentPageNumber += 1
                            }
                            
                            completion(true)
                        }
                        
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
        guard selectedCategory != nil else {
            return
        }
        
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
    
    /// 카테고리 삭제 api 호출
    func deleteCategoryApi(completion: @escaping (Bool) -> Void) {
        guard selectedCategory != nil else {
            return
        }
        
        SpendingCategoryAlamofire.shared.deleteCategory(selectedCategory!.id) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("카테고리 삭제 완료 \(jsonString)")
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
    
    /// 카테고리 이동 api 호출
    func moveCategoryApi(completion: @escaping (Bool) -> Void) {
        guard selectedCategory != nil else {
            return
        }
        
        let moveCategoryRequestDto = MoveCategoryRequestDto(fromType: getCategoryDetails(selectedCategory!).categoryIconTitle, toId: getCategoryDetails(selectedMoveCategory!).categoryId, toType: getCategoryDetails(selectedMoveCategory!).categoryIconTitle)
        
        SpendingCategoryAlamofire.shared.moveCategory(selectedCategory!.id, moveCategoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        self.deleteCategoryApi { success in
                            if success {
                                Log.debug("카테고리 이동 및 삭제 완료 \(jsonString)")
                                self.customCategories.removeAll { $0.id == self.selectedCategory!.id }
                                self.initPage() // 카테고리 삭제했으니 무한 스크롤 데이터 초기화
                                self.spendingCategories.removeAll { $0.id == self.selectedCategory!.id } // 총 카테고리 리스트에서 삭제한 카테고리 제거
                                
                                completion(true)
                            }
                        }
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
    
    func getCategoryDetails(_ category: SpendingCategoryData) -> (categoryIconTitle: String, categoryId: Int) {
        var categoryIconTitle = ""
        var categoryId = -1

        if category.isCustom == false { // isCustom false 인 경우 -> 정의된 카테고리
            if let category = SpendingCategoryIconList.fromIcon(category.icon) {
                categoryIconTitle = "DEFAULT"
                categoryId = abs(category.id)
            }
        } else { // 사용자 정의 카테고리
            categoryIconTitle = "CUSTOM"
            categoryId = category.id
        }
        return (categoryIconTitle, categoryId)
    }
    
    /// 특정 ID에 해당하는 지출내역 검색
    func getSpendingDetail(by id: Int) -> IndividualSpending? {
        return dailyDetailSpendings.first { $0.id == id }
    }
    
    func updateSpending(dto: AddSpendingHistoryResponseDto) {
        let id = selectSpending?.id
        
        if let firstIndex = dailyDetailSpendings.firstIndex(where: { $0.id == id }) {
            dailyDetailSpendings[firstIndex].update(spending: dto.data.spending)
        }
        selectSpending?.update(spending: dto.data.spending)
        Log.debug("spendingCategoryViewModel에서 지출 내역 삭제")
    }
}
