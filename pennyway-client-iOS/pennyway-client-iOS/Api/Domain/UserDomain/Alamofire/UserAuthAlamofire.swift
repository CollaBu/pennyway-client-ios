
import Alamofire
import Foundation

class UserAuthAlamofire: TokenHandler {
    static let shared = UserAuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func linkOAuthAccount(_ dto: OAuthUserData, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAuthAlamofire - linkOAuthAccount() called")
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: UserAuthRouter.linkOAuthAccount(dto: dto), completion: completion)
    }
    
    func unlinkOAuthAccount(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAuthAlamofire - unlinkOAuthAccount() called")
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: UserAuthRouter.unlinkOAuthAccount(dto: dto), completion: completion)
    }
}
