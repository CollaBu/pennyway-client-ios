
import Foundation

class OAuthAccountViewModel: ObservableObject {
    func linkOAuthAccountApi(completion: @escaping (Bool) -> Void) {
        let oauthUserData = OAuthUserData(oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "", idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "", nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "")

        UserAuthAlamofire.shared.linkOAuthAccount(oauthUserData) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    Log.debug(responseData)
                    KeychainHelper.deleteOAuthUserData()
                    completion(true)
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                    if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                        Log.info("StatusSpecificError occurred 4091: \(StatusSpecificError)")
                    }
                    completion(false)
                } else {
                    Log.error("Network request failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func unlinkOAuthAccountApi(completion: @escaping (Bool) -> Void) {

        UserAuthAlamofire.shared.unlinkOAuthAccount { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    Log.debug(responseData)
                    completion(true)
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                    if StatusSpecificError.domainError == .notFound && StatusSpecificError.code == NotFoundErrorCode.resourceNotFound.rawValue {
                        Log.info("StatusSpecificError occurred 4040: \(StatusSpecificError)")
                    }
                    completion(false)
                } else {
                    Log.error("Network request failed: \(error)")
                    completion(false)
                }
            }
        }
    }
}
