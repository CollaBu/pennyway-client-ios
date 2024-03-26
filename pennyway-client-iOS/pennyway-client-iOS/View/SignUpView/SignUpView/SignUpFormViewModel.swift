import SwiftUI
import Combine

class SignUpFormViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var confirmPw: String = ""
    @Published var showErrorName = false
    @Published var showErrorID = false
    @Published var showErrorPassword = false
    @Published var showErrorConfirmPw = false

    func validateName() {
        let nameRegex = "^[가-힣a-zA-Z]+$"
        showErrorName = !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
        print(showErrorName)
    }

    func validateID() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorID = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }

    func validatePassword() {
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?~]).{8,16}$"
        showErrorPassword = !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func validateConfirmPw() {
        showErrorConfirmPw = password != confirmPw
    }
}
