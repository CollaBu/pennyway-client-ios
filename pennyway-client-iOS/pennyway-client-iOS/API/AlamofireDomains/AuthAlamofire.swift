
import Foundation
import Alamofire
import os.log

class AuthAlamofire: TokenHandling {
    
    static let shared = AuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors:[BaseInterceptor()])
    
    var session : Session
    
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func sendSms(_ phone: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthAlamofire - sendSms() called userInput : %@ ", log: .default, type: .info, phone)
        
        self
            .session
            .request(AuthRouter.sendSms(phone: phone))
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func regist(_ username: String, _ name: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ", log: .default, type: .info, username, password, name)
        
        self
            .session
            .request(AuthRouter.regist(username: username, name: name, password: password))
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
