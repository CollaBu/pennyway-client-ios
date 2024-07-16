
import SwiftUI

class EditPhoneNumberViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var code = ""

    @Published var isFormValid = false
    @Published var showErrorPhoneNumberFormat = false
    @Published var showErrorVerificationCode = false
    @Published var showErrorExistingUser = false

    /// Timer
    @Published var isTimerHidden = true
    @Published var timerSeconds = 300
    @Published var isTimerRunning = false
    @Published var isDisabledButton = false

    func validateForm() {
        isFormValid = (!phoneNumber.isEmpty && !code.isEmpty && timerSeconds > 0)
    }

    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" && phoneNumber.count == 11 {
            showErrorPhoneNumberFormat = true
        } else {
            showErrorPhoneNumberFormat = false
        }
    }
}
