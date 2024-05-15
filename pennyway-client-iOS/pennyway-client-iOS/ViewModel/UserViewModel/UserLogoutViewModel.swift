
import os.log
import SwiftUI

class UserLogoutViewModel: ObservableObject {
    @Published var isLoggedOut = false

    func logout(completion: @escaping (Bool) -> Void) {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        self.isLoggedOut = true
                        os_log("Success Logout", log: .default, type: .debug)
                        completion(true)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):

                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
                completion(false)
            }
        }
    }
}
