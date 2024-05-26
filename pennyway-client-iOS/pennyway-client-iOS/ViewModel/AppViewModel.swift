
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isSplashShown: Bool = false
    @Published var checkLoginState = false

    init() {
        checkLoginStateApi()
    }

    func checkLoginStateApi() {
        UserAuthAlamofire.shared.checkLoginState { [weak self] result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug(response)
                        DispatchQueue.main.async {
                            self?.checkLoginState = true
                        }
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        DispatchQueue.main.async {
                            self?.checkLoginState = false
                        }
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                DispatchQueue.main.async {
                    self?.checkLoginState = false
                }
            }
        }
    }

    func logout() {
        isLoggedIn = false
    }

    func login() {
        isLoggedIn = true
    }
}
