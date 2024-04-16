import Foundation

class TermsAndConditionsViewModel: ObservableObject {
    func requestRegistAPI() {
        let signupDTO = SignUpRequestDTO(name: RegistrationManager.shared.name ?? "", username: RegistrationManager.shared.username ?? "", password: RegistrationManager.shared.password ?? "", phone: RegistrationManager.shared.formattedPhoneNumber ?? "", code: RegistrationManager.shared.verificationCode ?? "")

        AuthAlamofire.shared.signup(signupDTO) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        if let code = responseJSON?["code"] as? String {
                            if code == "2000" {
                                // 회원가입 성공

                            } else if code == "4220" {
                                // 입력 유효성 검사 오류
                            }
                        }
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                print("Failed to regist: \(error)")
            }
        }
    }
}
