
import Alamofire
import Foundation
import os.log

class OAuthAlamofire: TokenHandler {
    static let shared = OAuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    var session: Session
    
    private init() {
        session = Session(eventMonitors: monitors)
    }
    
    func oauthLogin(_ dto: OAuthLoginRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthLogin() called : %@ ,,  %@ ,, %@", log: .default, type: .info, dto.oauthId, dto.idToken, dto.provider)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: OAuthRouter.oauthLogin(dto: dto), completion: completion)
    }

    func oauthReceiveVerificationCode(_ dto: OAuthVerificationCodeRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthReceiveVerificationCode() called : %@ ,, %@", log: .default, type: .info, dto.phone, dto.provider)
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: OAuthRouter.oauthReceiveVerificationCode(dto: dto), completion: completion)
    }
    
    func oauthVerifyVerificationCode(_ dto: OAuthVerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthVerifyVerificationCode() called : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: OAuthRouter.oauthVerifyVerificationCode(dto: dto), completion: completion)
    }
    
    func linkOAuthToAccount(_ dto: LinkOAuthToAccountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - linkOAuthToAccount() called : %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.phone, dto.code, dto.provider)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: OAuthRouter.linkOAuthToAccount(dto: dto), completion: completion)
    }

    func oauthSignUp(_ dto: OAuthSignUpRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthSignUp() called : %@ ,, %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.name, dto.username, dto.phone, dto.code, dto.provider)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: OAuthRouter.oauthSignUp(dto: dto), completion: completion)
    }
}
