
import SwiftUI

class PhoneVerificationViewModel: ObservableObject {
    // MARK: Private

    private var timer: Timer?
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
        isFormValid = (!phoneNumber.isEmpty && !verificationCode.isEmpty && timerSeconds > 0)
    }

    // MARK: API

    func requestVerificationCodeAPI(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.sendVerificationCode(formattedPhoneNumber) { result in
                self.handleAPIResult(result: result, completion: completion)
            }
        }
    }

    func requestVerifyVerificationCodeAPI(completion: @escaping () -> Void) {
        if isFormValid {
            AuthAlamofire.shared.verifyVerificationCode(formattedPhoneNumber, verificationCode) { result in
                self.handleAPIResult(result: result, completion: completion)
            }
        }
    }

    func requestOAuthVerificationCodeAPI(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()

        if !showErrorPhoneNumberFormat {
            OAuthAlamofire.shared.oauthSendVerificationCode(formattedPhoneNumber, OAuthRegistrationManager.shared.provider) { result in
                self.handleAPIResult(result: result, completion: completion)
            }
        }
    }

    func requestOAuthVerifyVerificationCodeAPI(completion: @escaping () -> Void) {
        if isFormValid {
            OAuthAlamofire.shared.oauthVerifyVerificationCode(formattedPhoneNumber, verificationCode, OAuthRegistrationManager.shared.provider) { result in
                self.handleAPIResult(result: result, completion: completion)
            }
        }
    }

    private func handleAPIResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
        switch result {
        case let .success(data):
            if let responseData = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]

                    if let code = responseJSON?["code"] as? String {
                        switch code {
                        case "2000":
                            showErrorVerificationCode = false
                            if let smsData = responseJSON?["data"] as? [String: Any], let sms = smsData["sms"] as? [String: Any] {
                                if let existsUser = sms["existsUser"] as? Bool {
                                    OAuthRegistrationManager.shared.isExistUser = existsUser
                                }

                                if let oauth = sms["oauth"] as? Bool {
                                    OAuthRegistrationManager.shared.isOAuthUser = oauth
                                }
                                if let username = sms["username"] as? String {
                                    OAuthRegistrationManager.shared.username = username
                                }
                            }
                        case "4010", "4042":
                            showErrorVerificationCode = true
                        default:
                            showErrorVerificationCode = true
                            break
                        }
                    }
                    print(responseJSON as Any)
                } catch {
                    print("Error parsing response JSON: \(error)")
                }
            }
        case let .failure(error):
            print("Failed to verify: \(error)")
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
        timerSeconds = 10
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
        isTimerRunning = false
    }
}
