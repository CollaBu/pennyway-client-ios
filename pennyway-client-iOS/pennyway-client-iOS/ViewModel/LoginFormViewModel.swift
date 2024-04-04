import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var loginFailed: Bool = false

    func login() {
        if id != "jayang" || password != "dkssudgktpdy1" {
            loginFailed = true
        } else {
            loginFailed = false
        }
    }
}
