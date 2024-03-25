
import SwiftUI

class NumberVerificationViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var randomVerificationCode = ""
    @Published var timerSeconds = 120
    @Published var isTimerRunning = false
    @State private var timer: Timer?
    
    func generateRandomVerificationCode() {
        if !showErrorPhoneNumberFormat{
            randomVerificationCode = String(Int.random(in: 100000...999999))
        }
    }
    
    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" {
            showErrorPhoneNumberFormat = true
        } else{
            showErrorPhoneNumberFormat = false
        }
    }
    
    func judgeTimerRunning(){
        
        if !showErrorPhoneNumberFormat{
            if isTimerRunning {
                stopTimer()
                isTimerRunning = false
            } else {
                startTimer()
                isTimerRunning = true
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerSeconds > 0 && !self.isTimerRunning{
                self.timerSeconds -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerSeconds = 120
    }
    
}
