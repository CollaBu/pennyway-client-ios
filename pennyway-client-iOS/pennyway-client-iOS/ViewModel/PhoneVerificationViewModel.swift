
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

    // MARK: API

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

    func requestVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = VerificationRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.verifyVerificationCode(verificationDto) { result in
                self.handleVerificationApiResult(result: result, completion: completion)
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

    func requestOAuthVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let oauthVerificationDto = OAuthVerificationRequestDto(phone: formattedPhoneNumber, code: code, provider: OAuthRegistrationManager.shared.provider)

        if isFormValid {
            OAuthAlamofire.shared.oauthVerifyVerificationCode(oauthVerificationDto) { result in
                self.handleOAuthVerificationApiResult(result: result, completion: completion)
            }
        }
    }

    private func handleVerificationCodeApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)
                    print(response)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                print("Failed to verify: \(errorWithDomainErrorAndMessage)")
            } else {
                print("Failed to verify: \(error)")
            }
        }
        completion()
    }

    private func handleUserNameVerificationCodeApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        let findUserNameDto = FindUserNameRequestDto(phone: phone, code: code)
        AuthAlamofire.shared.findUserName(findUserNameDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(FindUserNameResponseDto.self, from: responseData)
                        self.username = response.data.user.username
                        print(response)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
        completion()
    }

    private func handleVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(VerificationResponseDto.self, from: responseData)
                    showErrorVerificationCode = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isOAuthUser = sms.oauth

                    print(response)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                if errorWithDomainErrorAndMessage.code == "4004" {
                    showErrorExistingUser = true
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                print("Failed to verify: \(error)")
            }
        }
        completion()
    }

    private func handleOAuthVerificationApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let response = try JSONDecoder().decode(OAuthVerificationResponseDto.self, from: responseData)

                    showErrorVerificationCode = false
                    let sms = response.data.sms
                    OAuthRegistrationManager.shared.isExistUser = sms.existsUser
                    OAuthRegistrationManager.shared.username = sms.username

                    print(response)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                if errorWithDomainErrorAndMessage.code == "4004" {
                    showErrorExistingUser = true
                } else {
                    showErrorVerificationCode = true
                }
            } else {
                print("Failed to verify: \(error)")
            }
        }
        completion()
    }

    // MARK: Timer function

    func judgeTimerRunning() {
        if !showErrorPhoneNumberFormat {
            if isTimerRunning {
                stopTimer()
            } else {
                startTimer()
            }
        }
    }

    func startTimer() {
        timerSeconds = 300
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerSeconds > 0 && self.isTimerRunning {
                self.timerSeconds -= 1
            } else {
                self.stopTimer()
                self.isDisabledButton = false
                self.isTimerHidden = true
            }
        }
        isTimerRunning = true
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
}
