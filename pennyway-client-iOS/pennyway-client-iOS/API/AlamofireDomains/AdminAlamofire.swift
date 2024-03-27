
import Foundation
import Alamofire
import os.log

class AdminAlamofire: TokenHandling {
    
    // 싱글턴 적용
    static let shared = AdminAlamofire()
    
    var session = Session.default
    
    
}
