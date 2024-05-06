
import os.log
import SwiftUI

class UserProfileViewModel: ObservableObject {
//    @Published var isSuccessLogout: Bool = false

    func logout() {
//        let logoutDto = LogoutRequestDto(accessToken: KeychainHelper.loadAccessToken() ?? "", refreshToken: HTTPCookieStorage.shared.)
        AuthAlamofire.shared.logout { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
//                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        os_log("Success Logout", log: .default, type: .debug)
//                        self.isSuccessLogout = true
                        print("Logout 됨")
                        NavigationUtil.popToRootView()
//                        print(response)

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
//
//        if isSuccessLogout {
//            NavigationUtil.popToRootView()
//            print(isSuccessLogout)
//            os_log("isSuccessLogout is true", log: .default, type: .debug)
//        }
    }
}
