
import Foundation
import Alamofire
import os.log

class AdminAlamofire: TokenHandling {
    
    static let shared = AdminAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors:[BaseInterceptor()])
    
    var session : Session
    
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
