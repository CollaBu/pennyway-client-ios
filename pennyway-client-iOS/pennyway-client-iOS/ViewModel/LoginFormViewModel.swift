import SwiftUI

class LoginFormViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false
    @Published var loginFailed: Bool = false
    
    func login() {
        if id != "jayang" || password != "dkssudgktpdy1" {
            loginFailed = true
        } else {
            loginFailed = false
        }
    }
    
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
                                    // 성공적으로 인증번호를 전송한 경우
                                    
                                } else if code == "4010" {
                                    // 포맷 오류
                                }
                            }
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
