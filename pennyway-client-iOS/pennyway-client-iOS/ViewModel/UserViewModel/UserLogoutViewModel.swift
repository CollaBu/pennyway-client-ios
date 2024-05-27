
import os.log
import SwiftUI

class UserLogoutViewModel: ObservableObject {
    @Published var isLoggedOut = false

    func logout(completion: @escaping (Bool) -> Void) {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):

                self.isLoggedOut = true
                Log.debug("Success Logout")
                KeychainHelper.deleteAccessToken()
                completion(true)

            case let .failure(error):

                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
                completion(false)
            }
        }
    }
}
