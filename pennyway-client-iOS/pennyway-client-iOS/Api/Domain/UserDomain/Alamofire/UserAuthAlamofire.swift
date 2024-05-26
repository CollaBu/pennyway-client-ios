
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
        Log.info("UserAuthAlamofire - linkOAuthAccount() called \(dto)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAuthRouter.linkOAuthAccount(dto: dto), completion: completion)
    }
    
    func unlinkOAuthAccount(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAuthAlamofire - unlinkOAuthAccount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAuthRouter.unlinkOAuthAccount, completion: completion)
    }
    
    func checkLoginState(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAuthAlamofire - checkLoginState() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAuthRouter.checkLoginState, completion: completion)
    }
    
    func refresh(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAuthAlamofire - refresh() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAuthRouter.refresh, completion: completion)
    }
}
