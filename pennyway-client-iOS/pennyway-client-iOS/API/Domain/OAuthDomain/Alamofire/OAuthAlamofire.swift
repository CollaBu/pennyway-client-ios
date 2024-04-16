
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
    
    func oauthLogin(_ dto: OAuthLoginRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthLogin() called : %@ ,,  %@ ,, %@", log: .default, type: .info, dto.oauthId, dto.idToken, dto.provider)
        
        session
            .request(OAuthRouter.oauthLogin(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func oauthSendVerificationCode(_ dto: OAuthVerificationCodeRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthSendVerificationCode() called : %@ ,, %@", log: .default, type: .info, dto.phone, dto.provider)
        
        session
            .request(OAuthRouter.oauthSendVerificationCode(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func oauthVerifyVerificationCode(_ dto: OAuthVerificationRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthVerifyVerificationCode() called : %@ ,, %@ ", log: .default, type: .info, dto.phone, dto.code)
        
        session
            .request(OAuthRouter.oauthVerifyVerificationCode(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func linkOAuthWithNormalAccount(_ dto: LinkOAuthToAccountRequestDTO, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - linkOAuthWithNormalAccount() called : %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.phone, dto.code, dto.provider)
        
        session
            .request(OAuthRouter.linkOAuthWithNormalAccount(dto: dto))
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

    func oauthSignUp(_ dto: OAuthSignUpRequestDTO,completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthRegist() called : %@ ,, %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, dto.idToken, dto.name, dto.username, dto.phone, dto.code, dto.provider)
        
        session
            .request(OAuthRouter.oauthSignUp(dto: dto))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
