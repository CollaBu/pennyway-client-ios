import Foundation

class TermsAndConditionsViewModel: ObservableObject {
    func requestRegistApi() {
        let signupDto = SignUpRequestDto(name: RegistrationManager.shared.name, username: RegistrationManager.shared.username, password: RegistrationManager.shared.password, phone: RegistrationManager.shared.formattedPhoneNumber ?? "", code: RegistrationManager.shared.code)

        AuthAlamofire.shared.signup(signupDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("회원가입 \(jsonString)")
                        }
                        
                        AnalyticsManager.shared.setUser("userId = \(response.data.user.id)")
                        AnalyticsManager.shared.trackEvent(AuthEvents.signUp, additionalParams: [
                            AnalyticsConstants.Parameter.oauthType: "none",
                        ])
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
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
