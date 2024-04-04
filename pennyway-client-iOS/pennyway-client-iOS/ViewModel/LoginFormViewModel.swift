import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var loginFailed: String? = nil

    func loginAPI() {
        if !isFormValid {
            AuthAlamofire.shared.login(id, password) { result in
                switch result {
                case let .success(data):
                    if let responseData = data {
                        do {
                            let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                            if let code = responseJSON?["code"] as? String {
                                if code == "2000" {
                                    // 성공적으로 로그인 된 경우
                                    self.loginFailed = nil
                                } else if code == "4010" {
                                    // 포맷 오류
                                    self.loginFailed = code
                                }
                            }
                            print(responseJSON)
                        } catch {
                            print("Error parsing response JSON: \(error)")
                        }
                    }
                case let .failure(error):

                    print("Failed Login: \(error)")
                }
            }
        }
    }
}


