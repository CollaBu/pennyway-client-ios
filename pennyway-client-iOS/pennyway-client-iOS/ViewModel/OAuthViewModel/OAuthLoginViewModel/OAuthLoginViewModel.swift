
import SwiftUI

class OAuthLoginViewModel: ObservableObject {
    var dto: OAuthLoginRequestDto

    private let loginUseCase: LoginUseCase

    init(dto: OAuthLoginRequestDto, loginUseCase: LoginUseCase = LoginUseCase(repository: DefaultLoginRepository())) {
        self.dto = dto
        self.loginUseCase = loginUseCase
    }

    func oauthLogin(completion: @escaping (Bool, String?) -> Void) {
        loginUseCase.oauthLogin(dto: dto) { success, errorMessage in
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
