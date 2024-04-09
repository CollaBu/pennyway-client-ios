
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
    
    func oauthLogin(_ oauthID: String, _ idToken: String, _ provider: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthAlamofire - oauthLogin() called ", log: .default, type: .info)
        
        session
            .request(OAuthRouter.oauthLogin(oauthID: oauthID, idToken: idToken, provider: provider))
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
