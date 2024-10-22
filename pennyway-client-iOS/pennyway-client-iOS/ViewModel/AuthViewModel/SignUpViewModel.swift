import Foundation

class SignUpViewModel: ObservableObject {
    private let signUpUseCase: SignUpUseCase

    init(signUpUseCase: SignUpUseCase = DefaultSignUpUseCase(repository: DefaultSignUpRepository())) {
        self.signUpUseCase = signUpUseCase
    }

    func signUp(completion: @escaping (Bool, UserId?) -> Void) {
        let model = SignUp(name: RegistrationManager.shared.name, username: RegistrationManager.shared.username, password: RegistrationManager.shared.password, phone: RegistrationManager.shared.formattedPhoneNumber ?? "", code: RegistrationManager.shared.code)

        signUpUseCase.signup(model: model) { success, userId in
            if success {
                Log.debug("[SignUpViewModel]-일반 회원가입 성공")
                completion(true, userId)
            } else {
                Log.error("Sign up failed")
                completion(false, nil)
            }
        }
    }

    func oauthSignUp(completion: @escaping (Bool, UserId?) -> Void) {
        let model = OAuthSignUp(oauthId: KeychainHelper.loadOAuthUserData()?.oauthId ?? "", idToken: KeychainHelper.loadOAuthUserData()?.idToken ?? "", nonce: KeychainHelper.loadOAuthUserData()?.nonce ?? "", name: OAuthRegistrationManager.shared.name, username: OAuthRegistrationManager.shared.username, phone: OAuthRegistrationManager.shared.formattedPhoneNumber ?? "", code: OAuthRegistrationManager.shared.code, provider: OAuthRegistrationManager.shared.provider)

        signUpUseCase.oauthSignUp(model: model) { success, userId in
            if success {
                Log.debug("[SignUpViewModel]-소셜 회원가입 성공")
                completion(true, userId)
            } else {
                Log.error("OAuth sign up failed")
                completion(false, nil)
            }
        }
    }
}
