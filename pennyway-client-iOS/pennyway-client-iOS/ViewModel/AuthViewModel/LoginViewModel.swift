import os.log
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccessful: Bool = false
    @Published var showErrorCodeContent: Bool = false

    let profileInfoViewModel = UserAccountViewModel()

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = LoginUseCase(repository: DefaultLoginRepository())) {
        self.loginUseCase = loginUseCase
    }

//    func loginApi(completion: @escaping (Bool) -> Void) {
//        if !isFormValid {
//            let loginDto = LoginRequestDto(username: username, password: password)
//            AuthAlamofire.shared.login(loginDto) { result in
//                switch result {
//                case let .success(data):
//                    if let responseData = data {
//                        do {
//                            let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
//                            self.isLoginSuccessful = true
//                            self.showErrorCodeContent = false
//                            self.username = ""
//                            self.password = ""
//                            self.profileInfoViewModel.getUserProfileApi { _ in
//                                Log.debug(response)
//                                completion(true)
//                            }
//
//                            AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
//                            AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
//                                AnalyticsConstants.Parameter.oauthType: "none",
//                                AnalyticsConstants.Parameter.isRefresh: false
//                            ])
//                        } catch {
//                            Log.fault("Error parsing response JSON: \(error)")
//                            completion(false)
//                        }
//                    }
//                case let .failure(error):
//                    self.isLoginSuccessful = false
//                    self.showErrorCodeContent = true
//                    if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
//                        Log.info("Failed to verify: \(errorWithDomainErrorAndMessage)")
//                    } else {
//                        Log.error("[LoginViewModel] Failed to verify: \(error)")
//                    }
//                    completion(false)
//                }
//            }
//        }
//    }
    func loginApi(completion: @escaping (Bool) -> Void) {
        loginUseCase.login(username: username, password: password) { success in
            DispatchQueue.main.async {
                self.isLoginSuccessful = success
                self.showErrorCodeContent = !success
                if success {
                    self.username = ""
                    self.password = ""
                    completion(true)
                }
                completion(false)
            }
        }
    }

    func dismissError() {
        showErrorCodeContent = false
    }
}
