
import SwiftUI

class NumberVerificationViewModel: ObservableObject {
    
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var randomVerificationCode = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var showErrorVerificationCode = true
    @Published var isFormValid = false
    
    //Timer
    @Published var timerSeconds = 10
    @Published var isTimerRunning = false
    @Published var isDisabledButton = false
    @State private var timer: Timer?
    
    func generateRandomVerificationCode() {
        if !showErrorPhoneNumberFormat && !isDisabledButton{
            randomVerificationCode = String(Int.random(in: 100000...999999))
            print(randomVerificationCode)
            isDisabledButton = true
        }
    }
    
    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" {
            showErrorPhoneNumberFormat = true
        } else{
            showErrorPhoneNumberFormat = false
        }
    }
    
    func validateNumberVerification(){
        if verificationCode == randomVerificationCode {
            showErrorVerificationCode = false
        } else {
            showErrorVerificationCode = true
        }
    }
    
    func validateForm() {
        isFormValid = !phoneNumber.isEmpty && !verificationCode.isEmpty
    }
    
    //MARK: API
    
    func requestVerificationCodeAPI() {
        validatePhoneNumber()
        
        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.sendSms(phoneNumber) { result in
                switch result {
                case .success(let data):
                    // 인증번호 적용
                    print("SMS sent successfully")
                case .failure(let error):
                
                    print("Failed to send SMS: \(error)")
                }
            }
        }
    }
    
    //MARK: Timer function
    
    func judgeTimerRunning(){
        
        if !showErrorPhoneNumberFormat{
            if isTimerRunning {
                stopTimer()
            } else {
                startTimer()
                self.isTimerRunning = true
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerSeconds > 0 && self.isTimerRunning{
                self.timerSeconds -= 1
            } else {
                self.stopTimer()
                self.isDisabledButton = false
            }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerSeconds = 10
        self.isTimerRunning = false
    }

}
