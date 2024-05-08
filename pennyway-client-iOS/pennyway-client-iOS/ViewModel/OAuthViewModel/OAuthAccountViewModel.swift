
import Foundation

class OAuthAccountViewModel: ObservableObject {
    func linkOAuthAccountApi(completion: @escaping (Bool) -> Void) {
        let oauthUserData = OAuthUserData(oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "", idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "", nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "")

        UserAuthAlamofire.shared.linkOAuthAccount(oauthUserData) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    Log.debug(responseData)
                    completion(true)
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                    completion(false)
                } else {
                    Log.error("Network request failed: \(error)")
                    completion(false)
                }
            }
        }
    }
}
