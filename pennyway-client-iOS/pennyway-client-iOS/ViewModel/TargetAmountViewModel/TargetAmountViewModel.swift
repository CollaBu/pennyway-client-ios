

import SwiftUI

class TargetAmountViewModel: ObservableObject {
    @Published var targetAmountData: TargetAmount? = nil
    @Published var isHiddenSuggestionView = true//추천 금액 뷰
    @Published var isPresentTargetAmount = true//당월 목표 금액 존재 여부

    func getTargetAmountForDateApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.getTargetAmountForDate { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForDateResponseDto.self, from: responseData)

                        let validTargetAmount = response.data.targetAmount
                       
                        if validTargetAmount.targetAmountDetail.isRead == true {
                            self.targetAmountData = validTargetAmount
                            self.isHiddenSuggestionView = true
                            self.isPresentTargetAmount = false
                        } else {
                            
                            self.getTargetAmountForPreviousMonthApi{ isPresent in
                                if isPresent{
                                    self.targetAmountData = validTargetAmount
                                    self.isHiddenSuggestionView = false
                                    self.isPresentTargetAmount = false
                                }else{
                                    self.deleteCurrentMonthTargetAmountApi{ _ in}
                                }
                            }
                            // TODO: getTargetAmountForPreviousMonth 요청
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
                        self.isHiddenSuggestionView = true
                        self.isPresentTargetAmount = false
                        // TODO: generateCurrentMonthDummyData 요청 + 추천 금액 보여주기 x + 목표 금액 설정하기 UI
                    }
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
    
    func getTargetAmountForPreviousMonthApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.getTargetAmountForPreviousMonth { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForPreviousMonthResponseDto.self, from: responseData)
                       
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("당월 이전 사용자 최신 목표 금액 조회 완료 \(jsonString)")
                        }
                        
                        let isPresent = response.data.targetAmount.isPresent
                        
                        if isPresent == true {
                            // TODO: 추천 금액 보여주기 + 목표 금액 설정하기 UI
                            completion(true)
                        } else {
                            // TODO: deleteCurrentMonthTargetAmount 요청
                            completion(false)
                        }

                        
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
    
    func deleteCurrentMonthTargetAmountApi(completion: @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.deleteCurrentMonthTargetAmount { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("당월 목표 금액 삭제 완료 \(jsonString)")
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
    
    func editCurrentMonthTargetAmountApi(completion: @escaping (Bool) -> Void) {
        let editCurrentMonthTargetAmountRequestDto = EditCurrentMonthTargetAmountRequestDto(amount: 0)
        
        TargetAmountAlamofire.shared.editCurrentMonthTargetAmount(editCurrentMonthTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("당월 목표 금액 수정 완료 \(jsonString)")
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
