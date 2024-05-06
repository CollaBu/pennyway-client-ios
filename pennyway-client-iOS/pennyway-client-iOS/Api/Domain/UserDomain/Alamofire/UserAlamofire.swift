
import Alamofire
import Foundation
import os.log

class UserAlamofire: TokenHandler {
    static let shared = UserAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getUserProfile(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("UserAlamofire - getUserProfile() called", log: .default, type: .info)
        
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: UserRouter.getUserProfile, completion: completion)
    }
}
