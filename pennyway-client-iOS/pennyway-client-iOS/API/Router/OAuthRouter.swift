
import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
   
    case oauthLogin(oauthID: String, idToken: String, provider: String)
    case oauthSendVerificationCode(phone: String)
    
    var method: HTTPMethod {
        switch self {
        case .oauthLogin, .oauthSendVerificationCode:
            return .post
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .oauthLogin:
            return "v1/auth/oauth/sign-in"
        case .oauthSendVerificationCode:
            return "v1/auth/oauth/phone"
        }
    }
    
    var parameters: Parameters {
        switch self {
      
        case let .oauthLogin(oauthID, idToken, _):
            return ["oauthId": oauthID, "idToken": idToken]
        case let .oauthSendVerificationCode(phone):
            return ["phone": phone]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        
        case let .oauthLogin(_, _, provider):
            let queryParameters = [URLQueryItem(name: "provider", value: provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case .oauthSendVerificationCode:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
