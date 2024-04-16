
import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
    case oauthLogin(dto: OAuthLoginRequestDTO)
    case oauthSendVerificationCode(dto: OAuthVerificationCodeRequestDTO)
    case oauthVerifyVerificationCode(dto: OAuthVerificationRequestDTO)
    case linkOAuthWithNormalAccount(dto: LinkOAuthToAccountRequestDTO)
    case oauthSignUp(dto: OAuthSignUpRequestDTO)
    
    var method: HTTPMethod {
        switch self {
        case .oauthLogin, .oauthSendVerificationCode, .oauthVerifyVerificationCode, .linkOAuthWithNormalAccount, .oauthSignUp:
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
        case .oauthSignUp:
            return "v1/auth/oauth/sign-up"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .oauthLogin(dto):
            return try? dto.asDictionary()
        case let .oauthSendVerificationCode(dto):
            return try? dto.asDictionary()
        case let .oauthVerifyVerificationCode(dto):
            return try? dto.asDictionary()
        case let .linkOAuthWithNormalAccount(dto):
            return try? dto.asDictionary()
        case let .oauthSignUp(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case let .oauthLogin(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthVerifyVerificationCode(dto):          
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case  let .linkOAuthWithNormalAccount(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthSendVerificationCode(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthSignUp(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        }
        return request
    }
}
