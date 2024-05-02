
import Foundation

class OAuthSignUpViewModel: ObservableObject {
    @Published var isSignUpSuccess = false

    func oauthSignUpApi() { // 소셜 회원가입
        let oauthSignUpDto = OAuthSignUpRequestDto(oauthId: OAuthRegistrationManager.shared.oauthId, idToken: KeychainHelper.loadIdToken() ?? "", nonce: OAuthRegistrationManager.shared.nonce, name: OAuthRegistrationManager.shared.name, username: OAuthRegistrationManager.shared.username, phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.oauthSignUp(oauthSignUpDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        print(response)
                        self.isSignUpSuccess = true
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                    self.isSignUpSuccess = false
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
    }
}
