
import Foundation

class OAuthRegistViewModel: ObservableObject {
    func oauthRegistAPI() {
        OAuthAlamofire.shared.oauthRegist(KeychainHelper.loadIDToken() ?? "", OAuthRegistrationManager.shared.name, OAuthRegistrationManager.shared.username, OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", OAuthRegistrationManager.shared.code, OAuthRegistrationManager.shared.provider) { result in
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
