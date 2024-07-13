
import Alamofire
import Foundation
import os.log

class UserAccountAlamofire {
    static let shared = UserAccountAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getUserProfile(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - getUserProfile() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.getUserProfile, completion: completion)
    }

    func deleteUserAccount(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - deleteUserAccount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.deleteUserAccount, completion: completion)
    }
    
    func registDeviceToken(_ dto: FcmTokenDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - registDeviceToken() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.registDeviceToken(dto: dto), completion: completion)
    }
    
    func settingOnAlarm(type: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - settingOnAlarm() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.settingOnAlarm(type: type), completion: completion)
    }
    
    func settingOffAlarm(type: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("UserAccountAlamofire - settingOffAlarm() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: UserAccountRouter.settingOffAlarm(type: type), completion: completion)
    }
}
