

import SwiftUI

class TargetAmountViewModel: ObservableObject {
    @Published var targetAmountData: TargetAmount? = nil
    @Published var isHiddenSuggestionView = true // 추천 금액 뷰
    @Published var isPresentTargetAmount = true // 당월 목표 금액 존재 여부
    
    @Published var generateTargetAmountId = -1
    
    @Published var recentTargetAmountData: RecentTargetAmount? = nil // 당월 이전 사용자의 최신 목표 금액

    func getTargetAmountForDateApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.getTargetAmountForDate { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForDateResponseDto.self, from: responseData)
                        let validTargetAmount = response.data.targetAmount
                        self.targetAmountData = validTargetAmount
                       
                        if validTargetAmount.targetAmountDetail.isRead == true {
                            // 추천 금액 보여주기 x
                            self.isHiddenSuggestionView = true

                        } else {
                            self.isHiddenSuggestionView = false
                            self.getTargetAmountForPreviousMonthApi()
                        }
                        
                        if validTargetAmount.targetAmountDetail.amount == -1 {
                            // 목표 금액 데이터 적용 x
                            self.isPresentTargetAmount = false
                        } else {
                            self.isPresentTargetAmount = true
                        }
    
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("당월 목표 금액 조회 \(jsonString)")
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
                    
                    if StatusSpecificError.domainError == .notFound {
                        // 추천 금액 보여주기 x + 목표 금액 설정하기 UI
                        self.isHiddenSuggestionView = true
                        self.isPresentTargetAmount = false
                        self.generateCurrentMonthDummyDataApi { _ in
                            // 당월 목표 금액 조회 재요청
                            self.getTargetAmountForDateApi { _ in }
                        }
                    }
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
    
    func getTargetAmountForPreviousMonthApi() {
        TargetAmountAlamofire.shared.getTargetAmountForPreviousMonth { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForPreviousMonthResponseDto.self, from: responseData)
                       
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("당월 이전 사용자 최신 목표 금액 조회 완료 \(jsonString)")
                        }
                        
                        self.recentTargetAmountData = response.data.targetAmount
                        let isPresent = response.data.targetAmount.isPresent
                        
                        if isPresent == true {
                            self.isHiddenSuggestionView = false
                            self.isPresentTargetAmount = false
                            // 추천 금액 보여주기 + 목표 금액 설정하기 UI
                        } else {
                            self.deleteCurrentMonthTargetAmountApi { _ in }
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
            }
        }
    }
    
    func generateCurrentMonthDummyDataApi(completion: @escaping (Bool) -> Void) {
        let generateCurrentMonthDummyDataRequestDto = GenerateCurrentMonthDummyDataRequestDto(year: Date.year(from: Date()), month: Date.month(from: Date()))
        
        TargetAmountAlamofire.shared.generateCurrentMonthDummyData(generateCurrentMonthDummyDataRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(CurrentMonthTargetAmountResponseDto.self, from: responseData)
                       
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("당월 목표 금액 더미값 생성 \(jsonString)")
                        }
                        self.generateTargetAmountId = response.data.targetAmount.id
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
    
    func deleteCurrentMonthTargetAmountApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.deleteCurrentMonthTargetAmount(targetAmountId: (targetAmountData?.targetAmountDetail.id)!) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("당월 목표 금액 삭제 완료 \(jsonString)")
                    }
                    self.isHiddenSuggestionView = true
                    self.isPresentTargetAmount = false
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
    
    func editCurrentMonthTargetAmountApi() {
        let editCurrentMonthTargetAmountRequestDto = EditCurrentMonthTargetAmountRequestDto(amount: recentTargetAmountData!.amount ?? 0)
        
        TargetAmountAlamofire.shared.editCurrentMonthTargetAmount(targetAmountId: targetAmountData?.targetAmountDetail.id ?? -1, dto: editCurrentMonthTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("당월 목표 금액 수정 완료 \(jsonString)")
                    }
                    // 당월 목표 금액 조회 재요청
                    self.getTargetAmountForDateApi { _ in }
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
}
