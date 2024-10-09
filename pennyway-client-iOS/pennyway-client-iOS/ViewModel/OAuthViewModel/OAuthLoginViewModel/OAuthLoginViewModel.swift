
import SwiftUI

class OAuthLoginViewModel: ObservableObject {
    var model: OAuthLogin
    private let loginUseCase: LoginUseCase

    init(model: OAuthLogin, loginUseCase: LoginUseCase = DefaultLoginUseCase(repository: DefaultLoginRepository())) {
        self.model = model
        self.loginUseCase = loginUseCase
    }

    func oauthLogin(completion: @escaping (Bool, String?) -> Void) {
        loginUseCase.oauthLogin(data: model) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    Log.debug("[OAuthLoginViewModel]-OAuth 로그인 성공")
                    completion(true, nil)
                } else {
                    Log.debug("[OAuthLoginViewModel]-OAuth 로그인 실패")
                    completion(false, errorMessage)
                }
            }
        }
    }
}
