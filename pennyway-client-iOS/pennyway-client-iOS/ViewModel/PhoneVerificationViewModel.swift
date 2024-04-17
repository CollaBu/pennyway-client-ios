
import SwiftUI

class PhoneVerificationViewModel: ObservableObject {
    // MARK: Private

    @State private var timer: Timer?
    private var formattedPhoneNumber: String {
        return PhoneNumberFormatter.formattedPhoneNumber(from: phoneNumber) ?? ""
    }

    // MARK: Internal

    @Published var phoneNumber: String = ""

    @Published var verificationCode: String = ""
    @Published var randomVerificationCode = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var showErrorVerificationCode = true
    @Published var isFormValid = false

    /// Timer
    @Published var isTimerHidden = true
    @Published var timerSeconds = 10
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
        isFormValid = !phoneNumber.isEmpty && !verificationCode.isEmpty
    }

    // MARK: API

    func requestVerificationCodeAPI(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let verificationCodeDTO = VerificationCodeRequestDTO(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(verificationCodeDTO) { result in
                self.handleVerificationCodeAPIResult(result: result, completion: completion)
            }
        }
    }

    func requestVerifyVerificationCodeAPI(completion: @escaping () -> Void) {
        let verificationDTO = VerificationRequestDTO(phone: formattedPhoneNumber, code: verificationCode)
        AuthAlamofire.shared.verifyVerificationCode(verificationDTO) { result in
            self.handleVerificationAPIResult(result: result, completion: completion)
        }
    }

    func requestOAuthVerificationCodeAPI(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()

        let oauthVerificationCodeDTO = OAuthVerificationCodeRequestDTO(phone: formattedPhoneNumber, provider: OAuthRegistrationManager.shared.provider)

        if !showErrorPhoneNumberFormat {
            OAuthAlamofire.shared.oauthReceiveVerificationCode(oauthVerificationCodeDTO) { result in
                self.handleVerificationCodeAPIResult(result: result, completion: completion)
            }
        }
    }

    func requestOAuthVerifyVerificationCodeAPI(completion: @escaping () -> Void) {
        let oauthVerificationDTO = OAuthVerificationRequestDTO(phone: formattedPhoneNumber, code: verificationCode, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.oauthVerifyVerificationCode(oauthVerificationDTO) { result in
            self.handleOAuthVerificationAPIResult(result: result, completion: completion)
        }
    }

    private func handleVerificationCodeAPIResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let smsResponse = try JSONDecoder().decode(SMSResponseDTO.self, from: responseData)
                    print(smsResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            print("Failed to verify: \(error)")
        }
        completion()
    }

    private func handleVerificationAPIResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let smsResponse = try JSONDecoder().decode(VerificationResponseDTO.self, from: responseData)
                    showErrorVerificationCode = false
                    let sms = smsResponse.data.sms
                    OAuthRegistrationManager.shared.isOAuthUser = sms.oauth

                    print(smsResponse)
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

    private func handleOAuthVerificationAPIResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let smsResponse = try JSONDecoder().decode(OAuthVerificationResponseDTO.self, from: responseData)

                    showErrorVerificationCode = false
                    let sms = smsResponse.data.sms
                    OAuthRegistrationManager.shared.isExistUser = sms.existsUser
                    OAuthRegistrationManager.shared.username = sms.username

                    print(smsResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        case let .failure(error):
            print("Failed to verify: \(error)")
            showErrorVerificationCode = true
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
                isTimerRunning = true
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
                self.isTimerHidden = true
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerSeconds = 10
        isTimerRunning = false
    }
}
