
import Alamofire
import Foundation
import os.log

class AuthAlamofire: TokenHandler {
    static let shared = AuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    /// let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(eventMonitors: monitors)
    }
    
    func receiveVerificationCode(_ dto: VerificationCodeRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - receiveVerificationCode() called userInput : %@ ", log: .default, type: .info, dto.phone)
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.receiveVerificationCode(dto: dto), completion: completion)
    }
    
    func verifyVerificationCode(_ dto: VerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - verifyVerificationCode() called with code : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.verifyVerificationCode(dto: dto), completion: completion)
    }

    func signup(_ dto: SignUpRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - signup() called userInput : %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.username, dto.name, dto.phone, dto.code)
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.signup(dto: dto), completion: completion)
    }
    
    func checkDuplicateUserName(_ dto: CheckDuplicateRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - checkDuplicateUserName() called userInput: %@", log: .default, type: .info, dto.username)
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.checkDuplicateUserName(dto: dto), completion: completion)
    }
    
    func login(_ dto: LoginRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - login() called userInput : %@ ", log: .default, type: .info, dto.username)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: AuthRouter.login(dto: dto), completion: completion)
    }
    
    func linkAccountToOAuth(_ dto: LinkAccountToOAuthRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - linkAccountToOAuth() called userInput : %@ ,, %@", log: .default, type: .info, dto.phone, dto.code)
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: AuthRouter.linkAccountToOAuth(dto: dto), completion: completion)
    }
}