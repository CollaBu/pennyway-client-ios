
import SwiftUI

class PhoneVerificationViewModel: ObservableObject {
    // MARK: Private

    private var timer: Timer?
    private var formattedPhoneNumber: String {
        return PhoneNumberFormatter.formattedPhoneNumber(from: phoneNumber) ?? ""
    }

    // MARK: Internal

    @Published var phoneNumber: String = ""

    @Published var code: String = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var showErrorVerificationCode = false
    @Published var showErrorExistingUser = false
    @Published var isFormValid = false

    @Published var phone: String = ""
    @Published var username: String?
    @Published var isFindUsername = false

    /// Timer
    @Published var isTimerHidden = true
    @Published var timerSeconds = 300
    @Published var isTimerRunning = false
    @Published var isDisabledButton = false

    func requestVerificationCodeAction() {
        if !showErrorPhoneNumberFormat && !isDisabledButton {
            isDisabledButton = true
            isTimerHidden = false
        }
    }

    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" && phoneNumber.count == 11 {
            showErrorPhoneNumberFormat = true
        } else {
            showErrorPhoneNumberFormat = false
        }
    }

    func validateForm() {
        isFormValid = (!phoneNumber.isEmpty && !code.isEmpty && timerSeconds > 0)
    }

    // MARK: 인증번호 코드 요청 API

    func requestVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let verificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(verificationCodeDto) { result in
                self.handleVerificationCodeApiResult(result: result, completion: completion)
            }
        }
    }

    func requestOAuthVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()

        let oauthVerificationCodeDto = OAuthVerificationCodeRequestDto(phone: formattedPhoneNumber, provider: OAuthRegistrationManager.shared.provider)

        if !showErrorPhoneNumberFormat {
            OAuthAlamofire.shared.oauthReceiveVerificationCode(oauthVerificationCodeDto) { result in
                self.handleVerificationCodeApiResult(result: result, completion: completion)
            }
        }
    }

    private func handleVerificationCodeApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)
                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.error("StatusSpecificError occurred: \(StatusSpecificError)")
            } else {
                Log.error("Network request failed: \(error)")
            }
        }
        completion()
    }
    
    // MARK: 일반 인증번호 검증 API

    func requestVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = VerificationRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.verifyVerificationCode(verificationDto) { result in
                self.handleVerificationApiResult(result: result, completion: completion)
            }
        }
    }

    private func handleVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(VerificationResponseDto.self, from: responseData)
                    showErrorVerificationCode = false
                    showErrorExistingUser = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isOAuthUser = sms.oauth
                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.error("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
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

    // MARK: OAuth 인증번호 검증 API

    func requestOAuthVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let oauthVerificationDto = OAuthVerificationRequestDto(phone: formattedPhoneNumber, code: code, provider: OAuthRegistrationManager.shared.provider)

        if isFormValid {
            OAuthAlamofire.shared.oauthVerifyVerificationCode(oauthVerificationDto) { result in
                self.handleOAuthVerificationApiResult(result: result, completion: completion)
            }
        }
    }

    private func handleOAuthVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(OAuthVerificationResponseDto.self, from: responseData)

                    showErrorVerificationCode = false
                    showErrorExistingUser = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isExistUser = sms.existsUser
                    OAuthRegistrationManager.shared.username = sms.username

                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.error("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
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

    // MARK: 아이디 찾기 인증번호 코드 요청 API

    func requestUserNameVerificationCodeApi(completion: @escaping () -> Void) { // 아이디 찾기 번호 인증
        validatePhoneNumber()
        requestVerificationCodeAction()
        let usernameVerificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveUserNameVerificationCode(usernameVerificationCodeDto) { result in
                self.handleUserNameVerificationCodeApiResult(result: result, completion: completion)
            }
        }
    }

    private func handleUserNameVerificationCodeApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) { // 아이디 찾기 번호 인증
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)
                    Log.debug(response)
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let StatusSpecificError = error as? StatusSpecificError {
                Log.error("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
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

    // MARK: 아이디 찾기 인증번호 검증 API

    func requestUserNameVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = FindUserNameRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.findUserName(verificationDto) { result in
                self.handleFindUserNameApi(result: result, completion: completion)
            }
        }
    }

    private func handleFindUserNameApi(result: Result<Data?, Error>, completion: @escaping () -> Void) {
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
                Log.error("StatusSpecificError occurred: \(StatusSpecificError)")

                if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
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

  

    // MARK: Timer function

    func judgeTimerRunning() {
        if !showErrorPhoneNumberFormat && !isTimerHidden {
            if isTimerRunning {
                stopTimer()
            } else {
                startTimer()
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerSeconds > 0 && self.isTimerRunning {
                self.timerSeconds -= 1
            } else {
                self.stopTimer()
                self.isDisabledButton = false
            }
        }
        isTimerRunning = true
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        isTimerHidden = true
        timerSeconds = 300
    }
}
