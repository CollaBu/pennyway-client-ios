import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var loginFailed: String? = nil

    func loginApi() {
        if !isFormValid {
            let loginDto = LoginRequestDto(username: id, password: password)
            AuthAlamofire.shared.login(loginDto) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                            self.loginFailed = nil
                            print(response)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):
                    if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                        print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                        self.loginFailed = errorWithDomainErrorAndMessage.code // 수정
                    } else {
                        print("Failed to verify: \(error)")
                    }
                }
            }
        }
    }
}
