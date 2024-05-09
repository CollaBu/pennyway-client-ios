import os.log
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var isLoginSuccessful = false
    @Published var showErrorCodeContent = false

    let profileInfoViewModel = ProfileInfoViewModel()

    func loginApi(completion: @escaping (Bool) -> Void) {
        if !isFormValid {
            let loginDto = LoginRequestDto(username: username, password: password)
            AuthAlamofire.shared.login(loginDto) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                            self.isLoginSuccessful = true
                            self.showErrorCodeContent = false
                            self.username = ""
                            self.password = ""
                            self.profileInfoViewModel.getUserProfileApi()
                            print(response)
                            completion(true)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                            completion(false)
                        }
                    }
                case let .failure(error):
                    self.isLoginSuccessful = false
                    self.showErrorCodeContent = true
                    completion(false)
                    if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                        print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                    } else {
                        print("Failed to verify: \(error)")
                    }
                }
            }
        }
    }
}
