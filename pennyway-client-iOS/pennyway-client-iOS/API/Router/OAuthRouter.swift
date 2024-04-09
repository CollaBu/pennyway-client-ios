
import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
    case oauthLogin(oauthId: String, idToken: String, provider: String)
    case oauthSendVerificationCode(phone: String, provider: String)
    case oauthVerifyVerificationCode(phone: String, code: String, provider: String)
    case linkOAuthWithNormalAccount(idToken: String, phone: String, provider: String)
    case oauthRegist(idToken: String, name: String,  username: String, phone: String, code: String, provider: String)
    
    var method: HTTPMethod {
        switch self {
        case .oauthLogin, .oauthSendVerificationCode, .oauthVerifyVerificationCode, .linkOAuthWithNormalAccount, .oauthRegist:
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
        case .oauthVerifyVerificationCode:
            return "v1/auth/oauth/phone/verification"
        case .linkOAuthWithNormalAccount:
            return "v1/auth/oauth/link-auth"
        case .oauthRegist:
            return "v1/auth/oauth/sign-up"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .oauthLogin(oauthId, idToken, _):
            return ["oauthId": oauthId, "idToken": idToken]
        case let .oauthSendVerificationCode(phone, _):
            return ["phone": phone]
        case let .oauthVerifyVerificationCode(phone, code, _):
            return ["phone": phone, "code": code]
        case let .linkOAuthWithNormalAccount(idToken, phone, _):
            return ["idToken": idToken, "phone": phone]
        case let .oauthRegist(idToken, name, username, phone, code, _):
            return ["idToken": idToken, "name": name, "username": username, "phone": phone, "code": code]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case let .oauthLogin(_, _, provider), 
            let .oauthVerifyVerificationCode(_, _, provider),
            let .linkOAuthWithNormalAccount(_,_,provider),
            let .oauthSendVerificationCode(_, provider),
            let .oauthRegist(_, _, _, _, _, provider):
            let queryParameters = [URLQueryItem(name: "provider", value: provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        }
        return request
    }
}
