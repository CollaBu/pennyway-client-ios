import os.log
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccessful: Bool = false
    @Published var showErrorCodeContent: Bool = false

    private let profileInfoViewModel = UserAccountViewModel()
    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = DefaultLoginUseCase(repository: DefaultLoginRepository(), chatRepository: DefaultChatServerRepository())) {
        self.loginUseCase = loginUseCase
    }

    func login(completion: @escaping (Bool) -> Void) {
        loginUseCase.login(username: username, password: password) { success in
            DispatchQueue.main.async {
                self.isLoginSuccessful = success
                self.showErrorCodeContent = !success
                if success {
                    self.username = ""
                    self.password = ""
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func dismissError() {
        showErrorCodeContent = false
    }
}
