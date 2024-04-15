
import Alamofire
import Foundation
import os.log

class AuthAlamofire: TokenHandling {
    static let shared = AuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    /// let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(eventMonitors: monitors)
    }
    
    func sendVerificationCode(_ phone: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - sendVerificationCode() called userInput : %@ ", log: .default, type: .info, phone)
        
        session
            .request(AuthRouter.sendVerificationCode(phone: phone))
            
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func verifyVerificationCode(_ phone: String, _ code: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - verifyVerificationCode() called with code : %@ ,, %@ ", log: .default, type: .info, phone, code)
        
        session
            .request(AuthRouter.verifyVerificationCode(phone: phone, code: code))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func regist(_ username: String, _ name: String, _ password: String, _ phone: String, _ code: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, username, password, name, phone, code)
        
        session
            .request(AuthRouter.regist(username: username, name: name, password: password, phone: phone, code: code))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkDuplicateUserName(_ username: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - checkDuplicateUserName() called ", log: .default, type: .info)
        
        session
            .request(AuthRouter.checkDuplicateUserName(username: username))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func login(_ username: String, _ password: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - login() called userInput : %@ ,, %@", log: .default, type: .info, username, password)
        
        session
            .request(AuthRouter.login(username: username, password: password))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response) // 토큰 저장
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func linkAccountToExistingOAuth(_ password: String, _ phone: String, _ code: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - linkExistingAccountToOAuth() called userInput : %@ ,, %@ ,, %@", log: .default, type: .info, password, phone, code)
        
        session
            .request(AuthRouter.linkAccountToExistingOAuth(password: password, phone: phone, code: code))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response) // 토큰 저장
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
