
import Foundation

class LinkOAuthToAccountViewModel: ObservableObject {
    func linkOAuthToAccountApi(completion: @escaping (Bool) -> Void) { // 바로 로그인 처리
        let linkOAuthToAccountDto = LinkOAuthToAccountRequestDto(oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "", idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "", nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "", phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.linkOAuthToAccount(linkOAuthToAccountDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)

                        AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                        AnalyticsManager.shared.trackEvent(AuthEvents.login, additionalParams: [
                            AnalyticsConstants.Parameter.oauthType: linkOAuthToAccountDto.provider,
                            AnalyticsConstants.Parameter.isRefresh: false,
                        ])

                        print(response)

                        completion(true)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
                completion(false)
            }
        }
    }
}
