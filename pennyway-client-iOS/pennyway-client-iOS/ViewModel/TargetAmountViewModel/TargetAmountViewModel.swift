

import SwiftUI

class TargetAmountViewModel: ObservableObject {
    @Published var totalSpent = 0
    @Published var targetAmountData: TargetAmount? = nil

    func getTargetAmountForDateApi(completion : @escaping (Bool) -> Void) {
        
        TargetAmountAlamofire.shared.getTargetAmountForDate { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForDateResponseDto.self, from: responseData)

                        let validTargetAmount = response.data.targetAmount
                       
                        if validTargetAmount.targetAmountDetail.isRead == true{
                            self.targetAmountData = validTargetAmount
                            //TODO: targetAmountData가 nil이 아니면 화면 안 나오도록
                        }else{
                            //TODO: getTargetAmountForPreviousMonth 요청
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
                    
                    //TODO: 404 오류 처리
                    if StatusSpecificError.domainError == .notFound{
                        //TODO: deleteCurrentMonthTargetAmount 요청
                        self.deleteCurrentMonthTargetAmountApi{_ in }
                    }
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
    
    
    func getTargetAmountForPreviousMonthApi(completion : @escaping (Bool) -> Void) {
        TargetAmountAlamofire.shared.getTargetAmountForPreviousMonth { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTargetAmountForPreviousMonthResponseDto.self, from: responseData)
                        
                        let isPresent = response.data.targetAmount.isPresent
                        
                        if isPresent == true{
                            //TODO: 추천 금액 보여주기 + 목표 금액 설정하기 UI
                        }else{
                            //TODO: deleteCurrentMonthTargetAmount 요청
                        }

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("당월 이전 사용자 최신 목표 금액 조회 완료 \(jsonString)")
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
    
    func deleteCurrentMonthTargetAmountApi(completion : @escaping (Bool) -> Void) {
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
    
    func editCurrentMonthTargetAmountApi(completion : @escaping (Bool) -> Void) {
         
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
