//
//  PhoneViewModelHandlers.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 7/25/24.
//

import Foundation

extension PhoneVerificationViewModel {
    // MARK: 인증번호 요청 handler

    func handleVerificationCodeApiResult(result: Result<Data?, Error>, type: VerificationType, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)
                    Log.debug(response)

                    if type == .general || type == .oauth {
                        RegistrationManager.shared.phoneNumber = phoneNumber
                    }

                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")

                if type == .username || type == .password, StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }

    // MARK: 일반 인증번호 검증 handler

    func handleVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(VerificationResponseDto.self, from: responseData)
                    showErrorVerificationCode = false
                    showErrorExistingUser = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isOAuthUser = sms.oauth
                    OAuthRegistrationManager.shared.username = sms.username ?? ""
                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = true
                    code = ""
                    isTimerHidden = true
                    stopTimer()
                    isDisabledButton = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }

    // MARK: OAuth 인증번호 검증 handler

    func handleOAuthVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(OAuthVerificationResponseDto.self, from: responseData)

                    showErrorVerificationCode = false
                    showErrorExistingUser = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isExistUser = sms.existsUser
                    OAuthRegistrationManager.shared.username = sms.username ?? ""

                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = true
                    code = ""
                    isTimerHidden = true
                    stopTimer()
                    isDisabledButton = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }

    // MARK: 아이디 찾기 인증번호 검증 handler

    func handleFindUserNameApi(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(FindUserNameResponseDto.self, from: responseData)
                    RegistrationManager.shared.username = response.data.user.username
                    showErrorVerificationCode = false
                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }

    // MARK: 비밀번호 찾기 번호 검증 handler

    func receivePwVerifyVerificationCode(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                showErrorVerificationCode = false
                Log.debug("비밀번호 찾기 인증번호 검증 성공")
                Log.debug("value: \(formattedPhoneNumber)")
                RegistrationManager.shared.phoneNumber = formattedPhoneNumber
                RegistrationManager.shared.code = code
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }

    // MARK: 전화번호 수정 handler

    func handleEditUserPhoneNumberApi(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)

                    Log.debug("전화번호 수정 완료 \(response)")
                    //                        updateUserField(fieldName: "username", value: self.inputId)
                } catch {
                    Log.fault("Error parsing response JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.info("Failed to verify: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict, StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                    showErrorExistingUser = true
                    showErrorVerificationCode = false
                    code = ""
                    isTimerHidden = true
                    stopTimer()
                    isDisabledButton = false
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                Log.error("Failed to verify: \(error)")
            }
            Log.debug("전화번호 수정 실패")
        }
        completion()
    }
}
