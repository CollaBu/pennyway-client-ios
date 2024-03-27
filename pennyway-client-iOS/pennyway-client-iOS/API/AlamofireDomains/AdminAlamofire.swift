
import Foundation
import Alamofire
import os.log

class AdminAlamofire: TokenHandling {
    
    static let shared = AdminAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    var session = Session.default
    

}
