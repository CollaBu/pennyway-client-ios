
import Alamofire
import Foundation
import os.log

class OAuthAlamofire: TokenHandling {
    static let shared = OAuthAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    var session: Session
    
    private init() {
        session = Session(eventMonitors: monitors)
    }
    
    func oauthLogin(_ dto: OAuthLoginRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthLogin() called : %@ ,,  %@ ,, %@", log: .default, type: .info, dto.oauthId, dto.idToken, dto.provider)
        
        session
            .request(OAuthRouter.oauthLogin(dto: dto))
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

    func oauthReceiveVerificationCode(_ dto: OAuthVerificationCodeRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthReceiveVerificationCode() called : %@ ,, %@", log: .default, type: .info, dto.phone, dto.provider)
        
        session
            .request(OAuthRouter.oauthReceiveVerificationCode(dto: dto))
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
    
    func oauthVerifyVerificationCode(_ dto: OAuthVerificationRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthVerifyVerificationCode() called : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        
        session
            .request(OAuthRouter.oauthVerifyVerificationCode(dto: dto))
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
    
    func linkOAuthToAccount(_ dto: LinkOAuthToAccountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - linkOAuthToAccount() called : %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.phone, dto.code, dto.provider)
        
        session
            .request(OAuthRouter.linkOAuthToAccount(dto: dto))
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

    func oauthSignUp(_ dto: OAuthSignUpRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthSignUp() called : %@ ,, %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.name, dto.username, dto.phone, dto.code, dto.provider)
        
        session
            .request(OAuthRouter.oauthSignUp(dto: dto))
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
}
