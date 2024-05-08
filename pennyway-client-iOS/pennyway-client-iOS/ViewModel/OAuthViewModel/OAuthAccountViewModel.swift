
import Foundation

class OAuthAccountViewModel: ObservableObject {
    func linkOAuthAccountApi() { // 바로 로그인 처리
        let oauthUserData = OAuthUserData(oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "", idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "", nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "")
        
        UserAuthAlamofire.shared.linkOAuthAccount(oauthUserData) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug(response)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}
