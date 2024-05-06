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
                        print(response)
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
