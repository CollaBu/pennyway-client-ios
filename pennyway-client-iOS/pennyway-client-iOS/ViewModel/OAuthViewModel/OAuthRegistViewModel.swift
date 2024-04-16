
import Foundation

class OAuthRegistViewModel: ObservableObject {
    func oauthRegistAPI() { // 소셜 회원가입
        let linkOAuthToAccountDTO = OAuthSignUpRequestDTO(idToken: KeychainHelper.loadIDToken() ?? "", name: OAuthRegistrationManager.shared.name, username: OAuthRegistrationManager.shared.username, phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        OAuthAlamofire.shared.oauthSignUp(linkOAuthToAccountDTO) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                // 성공

                            } else {
                                // 에러
                            }
                        }
                        print(responseJSON)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):

                print("Failed to oauthLogin: \(error)")
            }
        }
    }
}
