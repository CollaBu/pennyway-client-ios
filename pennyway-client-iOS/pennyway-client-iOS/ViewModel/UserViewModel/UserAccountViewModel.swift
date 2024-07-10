
import os.log
import SwiftUI

class UserAccountViewModel: ObservableObject {
    func getUserProfileApi(completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.getUserProfile { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetUserProfileResponseDto.self, from: responseData)
                        saveUserData(userData: response.data.user)
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 계정 조회 완료 \(jsonString)")
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

    func deleteUserAccountApi(completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.deleteUserAccount { result in
            switch result {
            case let .success(data):
                Log.debug("사용자 계정 삭제 완료")
                KeychainHelper.deleteAccessToken()
                TokenHandler.deleteAllRefreshTokens()
                completion(true)
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

    func settingOnAlarmApi(type: String, completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.settingOnAlarm(type: type) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(SettingAlarmResponseDto.self, from: responseData)
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 알람 활성화 \(jsonString)")
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

    func settingOffAlarmApi(type: String, completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.settingOffAlarm(type: type) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(SettingAlarmResponseDto.self, from: responseData)
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 알람 비활성화 \(jsonString)")
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
