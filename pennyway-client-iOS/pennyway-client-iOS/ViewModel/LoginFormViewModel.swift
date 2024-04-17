import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var loginFailed: String? = nil

    func loginAPI() {
        if !isFormValid {
            let loginDTO = LoginRequestDto(username: id, password: password)
            AuthAlamofire.shared.login(loginDTO) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let signupResponse = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                            self.loginFailed = nil
                            print(signupResponse)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):
                    self.loginFailed = "code"//수정
                    if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                        print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                    } else {
                        print("Failed to verify: \(error)")
                    }
                }
            }
        }
    }
}
