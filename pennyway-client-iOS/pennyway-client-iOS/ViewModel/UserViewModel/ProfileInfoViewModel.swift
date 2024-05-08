
import os.log
import SwiftUI

class ProfileInfoViewModel: ObservableObject {
    func getUserProfileApi() {
        UserAccountAlamofire.shared.getUserProfile { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetUserProfileResponseDto.self, from: responseData)
                        saveUserData(userData: response.data.user)
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            os_log("getUserProfileApi call: %@", log: .default, type: .debug, jsonString)
                        }
                    } catch {
                        os_log("getUserProfileApi error", log: .default, type: .fault)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    os_log("Failed to verify code: %@, message: %@", log: .default, type: .fault, StatusSpecificError.code, StatusSpecificError.message)
                } else {
                    os_log("Failed to verify: %@ ", log: .default, type: .error, error.localizedDescription)
                }
            }
        }
    }
}
