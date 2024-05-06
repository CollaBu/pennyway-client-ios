
import os.log
import SwiftUI

class UserProfileViewModel: ObservableObject {


    func logout() {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        os_log("Success Logout", log: .default, type: .debug)

                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):

                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
    }
}
