
import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
    case oauthLogin(oauthID: String, idToken: String, provider: String)
    case oauthSendVerificationCode(phone: String, provider: String)
    case oauthVerifyVerificationCode(phone: String, code: String, provider: String)
    case linkOAuthWithNormalAccount(idToken: String, phone: String, code: String, provider: String)
    case oauthRegist(idToken: String, name: String, username: String, phone: String, code: String, provider: String)
    case linkOAuthWithNomalAccountRegist(password: String, phone: String, code: String)
    
    var method: HTTPMethod {
        switch self {
        case .oauthLogin, .oauthSendVerificationCode, .oauthVerifyVerificationCode, .linkOAuthWithNormalAccount, .linkOAuthWithNomalAccountRegist, .oauthRegist:
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
        case .linkOAuthWithNomalAccountRegist:
            return "v1/auth/link-oauth"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .oauthLogin(oauthID, idToken, _):
            return ["oauthId": oauthID, "idToken": idToken]
        case let .oauthSendVerificationCode(phone, _):
            return ["phone": phone]
        case let .oauthVerifyVerificationCode(phone, code, _):
            return ["phone": phone, "code": code]
        case let .linkOAuthWithNormalAccount(idToken, phone, code,_):
            return ["idToken": idToken, "phone": phone, "code": code]
        case let .oauthRegist(idToken, name, username, phone, code, _):
            return ["idToken": idToken, "name": name, "username": username, "phone": phone, "code": code]
        case let .linkOAuthWithNomalAccountRegist(password, phone, code):
            return ["password": password, "phone": phone, "code": code]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case let .oauthLogin(_, _, provider), 
             let .oauthVerifyVerificationCode(_, _, provider),
             let .linkOAuthWithNormalAccount(_, _, _,provider),
             let .oauthSendVerificationCode(_, provider),
             let .oauthRegist(_, _, _, _, _, provider):
            let queryParameters = [URLQueryItem(name: "provider", value: provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case .linkOAuthWithNomalAccountRegist:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
