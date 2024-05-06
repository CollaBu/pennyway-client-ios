
import os.log
import SwiftUI

class UserProfileViewModel: ObservableObject {
    let appViewModel: AppViewModel

    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    func logout() {
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        os_log("Success Logout", log: .default, type: .debug)
                        self.appViewModel.isLoggedIn = false
                        NavigationUtil.popToRootView()
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
