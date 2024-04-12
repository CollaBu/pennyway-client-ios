
import Foundation

class OAuthAccountLinkingViewModel: ObservableObject {
    func linkOAuthWithNormalAccountAPI() { // 바로 로그인 처리
        OAuthAlamofire.shared.linkOAuthWithNormalAccount(KeychainHelper.loadIDToken() ?? "", OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", OAuthRegistrationManager.shared.code, OAuthRegistrationManager.shared.provider) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                // 성공
                            } else if code == "4000" {
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