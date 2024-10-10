import Alamofire
import Foundation
import os.log

class AuthAlamofire {
    static let shared = AuthAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    var logoutInterceptor: Session

    private init() {
        session = Session(eventMonitors: monitors)
        logoutInterceptor = Session(interceptor: interceptors, eventMonitors: monitors)
    }

    func receiveVerificationCode(_ dto: VerificationCodeRequestDto, type: VerificationType, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - receiveVerificationCode() called userInput: \(dto.phone)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.receiveVerificationCode(dto: dto, type: type), completion: completion)
    }

    func receivePwVerifyVerificationCode(_ dto: VerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) { // 비밀번호 찾기 번호인증 검증
        Log.info("AuthAlamofire - receivePwVerifyVerificationCode() called userInput: \(dto.phone), \(dto.code)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.receivePwVerifyVerificationCode(dto: dto), completion: completion)
    }

    func verifyVerificationCode(_ dto: VerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - verifyVerificationCode() called with code: \(dto.phone), \(dto.code)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.verifyVerificationCode(dto: dto), completion: completion)
    }

    func signup(_ dto: SignUpRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - signup() called userInput: \(dto.username), \(dto.name), \(dto.phone), \(dto.code)")
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.signup(dto: dto), completion: completion)
    }

    func checkDuplicateUserName(_ dto: CheckDuplicateRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - checkDuplicateUserName() called userInput: \(dto.username)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.checkDuplicateUserName(dto: dto), completion: completion)
    }

    func login(_ dto: LoginRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - login() called userInput: \(dto.username)")
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.login(dto: dto), completion: completion)
    }

    func logout(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - logout() called")
        ApiRequstHandler.shared.requestWithErrorHandling(session: logoutInterceptor, router: AuthRouter.logout, completion: completion)
    }

    func linkAccountToOAuth(_ dto: LinkAccountToOAuthRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - linkAccountToOAuth() called userInput: \(dto.phone), \(dto.code)")
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.linkAccountToOAuth(dto: dto), completion: completion)
    }

    func findUserName(_ dto: FindUserNameRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - findUserName() called userInput: \(dto.phone), \(dto.code)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.findUserName(dto: dto), completion: completion)
    }

    func requestResetPw(_ dto: RequestResetPwDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - requestResetPw() called userInput: \(dto.phone), \(dto.code), \(dto.newPassword)")
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.requestResetPw(dto: dto), completion: completion)
    }

    func refresh(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("AuthAlamofire - refresh() called")
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.refresh, completion: completion)
    }
}
