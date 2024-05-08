
import Foundation

class OAuthAccountLinkingViewModel: ObservableObject {
    func linkOAuthToAccountApi() { // 바로 로그인 처리
        let linkOAuthToAccountDto = LinkOAuthToAccountRequestDto(oauthId: KeychainHelper.loadIdToken()?.oauthId ?? "", idToken: KeychainHelper.loadIdToken()?.idToken ?? "", nonce: KeychainHelper.loadIdToken()?.nonce ?? "", phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.linkOAuthToAccount(linkOAuthToAccountDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        print(response)
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
            }
        }
    }
}
