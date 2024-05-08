
import SwiftUI

class OAuthLoginViewModel: ObservableObject {
    var dto: OAuthLoginRequestDto

    init(dto: OAuthLoginRequestDto) {
        self.dto = dto
    }

    func oauthLoginApi(completion: @escaping (Bool, String?) -> Void) {
        OAuthAlamofire.shared.oauthLogin(dto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        let isOAuthExistUser = response.data.user.id
                        if isOAuthExistUser != -1 {
                            KeychainHelper.deleteOAuthUserData()
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
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
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
