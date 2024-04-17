
import SwiftUI

class OAuthLoginViewModel: ObservableObject {
    var oauthId: String
    var provider: String

    init(oauthId: String, provider: String) {
        self.oauthId = oauthId
        self.provider = provider
    }

    func oauthLoginAPI(completion: @escaping (Bool, String?) -> Void) {
        let oauthLoginDto = OAuthLoginRequestDto(oauthId: oauthId, idToken: KeychainHelper.loadIDToken() ?? "", provider: provider)

        OAuthAlamofire.shared.oauthLogin(oauthLoginDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        let isOAuthExistUser = response.data.user.id
                        if isOAuthExistUser != -1 {
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        }
                        print(response)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                        completion(false, "Error parsing response JSON")
                        return
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
                completion(false, error.localizedDescription)
                return
            }
        }
    }
}
