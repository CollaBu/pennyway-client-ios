import Combine
import SwiftUI

class SignUpFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var confirmPw: String = ""
    @Published var showErrorName = false
    @Published var showErrorID = false
    @Published var showErrorPassword = false
    @Published var showErrorConfirmPw = false
    @Published var isFormValid: Bool = false

    @State private var isExistUser = OAuthRegistrationManager.shared.isExistUser
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration

    func validateForm() {
        if !isOAuthRegistration {
            if !name.isEmpty && !id.isEmpty && !password.isEmpty && password == confirmPw && !showErrorName && !showErrorID && !showErrorPassword && !showErrorConfirmPw {
                isFormValid = true
            } else {
                isFormValid = false
            }
        } else {
            if isExistUser {
                if !password.isEmpty && password == confirmPw && !showErrorPassword && !showErrorConfirmPw {
                    isFormValid = true
                } else {
                    isFormValid = false
                }
            } else {
                if !name.isEmpty && !id.isEmpty && !showErrorName && !showErrorID {
                    isFormValid = true
                } else {
                    isFormValid = false
                }
            }
        }
    }

    func validatePwForm() { 
        if !password.isEmpty && password == confirmPw && !showErrorPassword && !showErrorConfirmPw {
            isFormValid = true
        }
    }

    func validateName() {
        let nameRegex = "^[가-힣a-zA-Z]+$"
        showErrorName = !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }

    func validateID() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorID = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }

    func validatePassword() {
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,16}$"
        showErrorPassword = !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func validateConfirmPw() {
        showErrorConfirmPw = password != confirmPw
    }

    func checkDuplicateUserNameAPI() {
        AuthAlamofire.shared.checkDuplicateUserName(id) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                // 확인

                            } else if code == "4000" {
                                // 중복된 아이디
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
}
