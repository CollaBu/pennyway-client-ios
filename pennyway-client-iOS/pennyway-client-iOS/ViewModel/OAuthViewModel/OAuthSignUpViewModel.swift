
import Foundation

class OAuthSignUpViewModel: ObservableObject {
    func oauthSignUpAPI() { // 소셜 회원가입
        let oauthSignUpDto = OAuthSignUpRequestDto(idToken: KeychainHelper.loadIDToken() ?? "", name: OAuthRegistrationManager.shared.name, username: OAuthRegistrationManager.shared.username, phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.oauthSignUp(oauthSignUpDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let signupResponse = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        print(signupResponse)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
    }
}
