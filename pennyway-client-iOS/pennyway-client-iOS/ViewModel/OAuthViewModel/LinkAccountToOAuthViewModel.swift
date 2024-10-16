import Foundation

class LinkAccountToOAuthViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = DefaultLoginUseCase(repository: DefaultLoginRepository())) {
        self.loginUseCase = loginUseCase
    }

    func linkAccountToOAuthApi(completion: @escaping (Bool) -> Void) { // 바로 로그인 처리
        let model = LinkAccountToOAuth(password: RegistrationManager.shared.password, phone: RegistrationManager.shared.formattedPhoneNumber ?? "", code: RegistrationManager.shared.code)

        loginUseCase.linkAccountToOAuth(data: model) { success, userId in
            if success {
                AnalyticsManager.shared.setUser("userId = \(String(describing: userId))")
                AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                    AnalyticsConstants.Parameter.oauthType: "none",
                    AnalyticsConstants.Parameter.isRefresh: false,
                ])
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
