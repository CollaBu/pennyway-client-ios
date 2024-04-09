
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
    
    func oauthLogin(_ oauthId: String, _ idToken: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthLogin() called : %@ ,,  %@ ,, %@", log: .default, type: .info, oauthId, idToken, provider)
        
        session
            .request(OAuthRouter.oauthLogin(oauthId: oauthId, idToken: idToken, provider: provider))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func oauthSendVerificationCode(_ phone: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthSendVerificationCode() called : %@ ,, %@", log: .default, type: .info, phone, provider)
        
        session
            .request(OAuthRouter.oauthSendVerificationCode(phone: phone, provider: provider))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }

    func oauthVerifyVerificationCode(_ phone: String, _ code: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthVerifyVerificationCode() called : %@ ,, %@ ", log: .default, type: .info, phone, code)
        
        session
            .request(OAuthRouter.oauthVerifyVerificationCode(phone: phone, code: code, provider: provider))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    
    func linkOAuthWithNormalAccount(_ idToken: String, _ phone: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - linkOAuthWithNormalAccount() called : %@ ,, %@ ,, %@", log: .default, type: .info, idToken, phone, provider)
        
        session
            .request(OAuthRouter.linkOAuthWithNormalAccount(idToken: idToken, phone: phone, provider: provider))
            .response { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
    func oauthRegist(_ idToken: String, _ name: String, _ username: String, _ phone: String, _ code: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("OAuthAlamofire - oauthRegist() called : %@ ,, %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, idToken, name , username, phone, code, provider)
        
        session
            .request(OAuthRouter.oauthRegist(idToken: idToken, name: name,  username: username, phone: phone, code: code, provider: provider))
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
