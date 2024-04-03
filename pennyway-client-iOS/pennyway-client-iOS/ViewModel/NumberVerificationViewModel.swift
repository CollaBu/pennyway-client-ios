
import SwiftUI

class NumberVerificationViewModel: ObservableObject {
    // MARK: Private

    @State private var timer: Timer?

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

    func generateRandomVerificationCode() {
        if !showErrorPhoneNumberFormat && !isDisabledButton {
            randomVerificationCode = String(Int.random(in: 100_000 ... 999_999))
            print(randomVerificationCode)
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

    func validateNumberVerification() {
        if verificationCode == randomVerificationCode {
            showErrorVerificationCode = false
        } else {
            showErrorVerificationCode = true
        }
    }

    func validateForm() {
        isFormValid = !phoneNumber.isEmpty && !verificationCode.isEmpty
    }

    // MARK: API

    func requestVerificationCodeAPI() {
        validatePhoneNumber()

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.sendVerificationCode(phoneNumber) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                            if let code = responseJSON?["code"] as? String {
                                if code == "2000" {
                                    // 성공적으로 인증번호를 전송한 경우

                                } else if code == "4220" {
                                    // 포맷 오류
                                }
                            }
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):

                    print("Failed to send SMS: \(error)")
                }
            }
        }
    }

    func requestVerifyVerificationCodeAPI() {
        AuthAlamofire.shared.verifyVerificationCode(phoneNumber, verificationCode) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                // 인증 성공

                            } else if code == "4000" {
                                // 인증번호 만료, 인증번호 매칭 오류, 사용중인 전화번호
                            }
                        }
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):

                print("Failed to verify: \(error)")
            }
        }
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
