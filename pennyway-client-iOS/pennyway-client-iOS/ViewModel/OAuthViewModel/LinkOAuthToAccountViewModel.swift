
import Foundation

class LinkOAuthToAccountViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = DefaultLoginUseCase(repository: DefaultLoginRepository())) {
        self.loginUseCase = loginUseCase
    }

    func linkOAuthToAccountApi(completion: @escaping (Bool) -> Void) { // 바로 로그인 처리
        let model = LinkOAuthToAccount(
            oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "",
            idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "",
            nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "",
            phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "",
            code: OAuthRegistrationManager.shared.code,
            provider: OAuthRegistrationManager.shared.provider
        )

        loginUseCase.linkOAuthToAccount(data: model) { success, userId in
            if success {
                AnalyticsManager.shared.setUser("userId = \(String(describing: userId))")
                AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                    AnalyticsConstants.Parameter.oauthType: model.provider,
                    AnalyticsConstants.Parameter.isRefresh: false,
                ])
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
