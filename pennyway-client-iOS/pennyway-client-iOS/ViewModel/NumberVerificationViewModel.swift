
import SwiftUI

class PhoneNumberVerificationViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var randomVerificationCode = ""
    
    func generateRandomVerificationCode() {
        if !showErrorPhoneNumberFormat{
            randomVerificationCode = String(Int.random(in: 100000...999999))
            print(randomVerificationCode)
        }
    }
    
    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" {
            showErrorPhoneNumberFormat = true
        } else{
            showErrorPhoneNumberFormat = false
        }
    }
}
