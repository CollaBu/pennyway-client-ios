
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
    
    func receiveVerificationCode(_ dto: VerificationCodeRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - receiveVerificationCode() called userInput : %@ ", log: .default, type: .info, dto.phone)
        
        session
            .request(AuthRouter.receiveVerificationCode(dto: dto))
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func verifyVerificationCode(_ dto: VerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - verifyVerificationCode() called with code : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        
        session
            .request(AuthRouter.verifyVerificationCode(dto: dto))
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }

    func signup(_ dto: SignUpRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - signup() called userInput : %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.username, dto.name, dto.phone, dto.code)
        
        session
            .request(AuthRouter.signup(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func checkDuplicateUserName(_ dto: DuplicateCheckRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - checkDuplicateUserName() called userInput: %@", log: .default, type: .info, dto.username)
        
        session
            .request(AuthRouter.checkDuplicateUserName(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func login(_ dto: LoginRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - login() called userInput : %@ ", log: .default, type: .info, dto.username)
        
        session
            .request(AuthRouter.login(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func linkAccountToOAuth(_ dto: LinkAccountToOAuthRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - linkAccountToOAuth() called userInput : %@ ,, %@", log: .default, type: .info, dto.phone, dto.code)
        
        session
            .request(AuthRouter.linkAccountToOAuth(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case let .failure(error):
                    if let responseData = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponseDto.self, from: responseData),
                       let responseError = ErrorCodeMapper.mapError(statusCode, code: errorResponse.code, message: errorResponse.message)
                    {
                        let errorWithDomainErrorAndMessage = ErrorWithDomainErrorAndMessage(domainError: responseError.domainError, code: responseError.code, message: responseError.message)
                        completion(.failure(errorWithDomainErrorAndMessage))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
