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
    @State private var isOAuthUser = OAuthRegistrationManager.shared.isOAuthUser
    @State private var isOAuthRegistration = OAuthRegistrationManager.shared.isOAuthRegistration
    
    func validateForm() {
        if isOAuthRegistration {
            if !isExistUser {
                if !name.isEmpty && !id.isEmpty && !showErrorName && !showErrorID {
                    isFormValid = true
                } else {
                    isFormValid = false
                }
            }
        } else {
            if isOAuthUser {
                if !password.isEmpty && password == confirmPw && !showErrorPassword && !showErrorConfirmPw {
                    isFormValid = true
                } else {
                    isFormValid = false
                }
            } else {
                if !name.isEmpty && !id.isEmpty && !password.isEmpty && password == confirmPw && !showErrorName && !showErrorID && !showErrorPassword && !showErrorConfirmPw {
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
        let nameRegex = "^[가-힣a-z]{2,8}$"
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
        let duplicateCheckDto = DuplicateCheckRequestDto(username: id)
        AuthAlamofire.shared.checkDuplicateUserName(duplicateCheckDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(DuplicateCheckResponseDto.self, from: responseData)

                        print(response)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
    }
}
