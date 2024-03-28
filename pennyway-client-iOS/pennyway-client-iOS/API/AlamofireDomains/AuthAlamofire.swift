
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
    
    func sendVerificationCode(_ phone: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthAlamofire - sendVerificationCode() called userInput : %@ ", log: .default, type: .info, phone)
        
        self
            .session
            .request(AuthRouter.sendVerificationCode(phone: phone))
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func verifyVerificationCode(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthAlamofire - verifyVerificationCode() called with code : %@ ,, %@ ", log: .default, type: .info, phone, code)
        
        self
            .session
            .request(AuthRouter.verifyVerificationCode(phone: phone, code: code))
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func regist(_ username: String, _ name: String, _ password: String, _ phone: String, code: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, username, password, name, phone, code)
        
        self
            .session
            .request(AuthRouter.regist(username: username, name: name, password: password, phone: phone, code: code))
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
