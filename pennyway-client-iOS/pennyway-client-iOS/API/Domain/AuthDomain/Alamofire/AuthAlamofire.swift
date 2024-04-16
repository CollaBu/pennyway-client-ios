
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
    
    func sendVerificationCode(_ dto: VerificationCodeRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - sendVerificationCode() called userInput : %@ ", log: .default, type: .info, dto.phone)
        
        session
            .request(AuthRouter.sendVerificationCode(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func verifyVerificationCode(_ dto: VerificationRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - verifyVerificationCode() called with code : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        
        session
            .request(AuthRouter.verifyVerificationCode(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func signup(_ dto: SignUpRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.username, dto.password, dto.name, dto.phone, dto.code)
        
        session
            .request(AuthRouter.signup(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkDuplicateUserName(_ dto: DuplicateCheckRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - checkDuplicateUserName() called ", log: .default, type: .info)
        
        session
            .request(AuthRouter.checkDuplicateUserName(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func login(_ dto: LoginRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - login() called userInput : %@ ,, %@", log: .default, type: .info, dto.username, dto.password)
        
        session
            .request(AuthRouter.login(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func linkAccountToExistingOAuth(_ dto: LinkAccountToOAuthRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - linkExistingAccountToOAuth() called userInput : %@ ,, %@ ,, %@", log: .default, type: .info, dto.password, dto.phone, dto.code)
        
        session
            .request(AuthRouter.linkAccountToExistingOAuth(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
