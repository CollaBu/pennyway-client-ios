
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
    
    func regist(_ username: String, _ name: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AdminAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ", log: .default, type: .info, username, password, name)
        
        self
            .session
            .request(AdminRouter.regist(username: username, name: name, password: password))
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
