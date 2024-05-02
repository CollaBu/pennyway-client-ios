import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var isLoginSuccessful = false
    @Published var showErrorCodeContent = false

    let appViewModel: AppViewModel

    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    func loginApi() {
        if !isFormValid {
            let loginDto = LoginRequestDto(username: id, password: password)
            AuthAlamofire.shared.login(loginDto) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                            self.isLoginSuccessful = true
                            self.showErrorCodeContent = false

                            self.appViewModel.isLoggedIn = true

                            print(response)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):
                    self.isLoginSuccessful = false
                    self.showErrorCodeContent = true
                    self.appViewModel.isLoggedIn = false

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
