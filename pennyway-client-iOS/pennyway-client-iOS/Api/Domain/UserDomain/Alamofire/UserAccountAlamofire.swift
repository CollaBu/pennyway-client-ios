
import Alamofire
import Foundation
import os.log

class UserAccountAlamofire: TokenHandler {
    static let shared = UserAccountAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getUserProfile(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("UserAccountAlamofire - getUserProfile() called", log: .default, type: .info)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: UserAccountRouter.getUserProfile, completion: completion)
    }
    func deleteUserAccount(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("UserAccountAlamofire - deleteUserAccount() called", log: .default, type: .info)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: UserAccountRouter.deleteUserAccount, completion: completion)
    }
}
