
import Alamofire
import Foundation

enum UserAuthRouter: URLRequestConvertible {
    case linkOAuthAccount(dto: OAuthUserData)
    case unlinkOAuthAccount, checkLoginState, refresh
    
    var method: HTTPMethod {
        switch self {
        case .linkOAuthAccount:
            return .put
        case .unlinkOAuthAccount:
            return .delete
        case .checkLoginState, .refresh:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .linkOAuthAccount, .unlinkOAuthAccount:
            return "v1/link-oauth"
        case .checkLoginState:
            return "v1/auth"
        case .refresh:
            return "v1/auth/refresh"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .linkOAuthAccount(dto):
            return try? dto.asDictionary()
        case .unlinkOAuthAccount, .checkLoginState, .refresh:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .linkOAuthAccount:
            let queryParameters = [URLQueryItem(name: "provider", value: OAuthRegistrationManager.shared.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
  
        case .unlinkOAuthAccount:
            let queryParameters = [URLQueryItem(name: "provider", value: OAuthRegistrationManager.shared.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        
        case .checkLoginState:
            request = URLRequest.createURLRequest(url: url, method: method)
        
        case .refresh:
            request = URLRequest.createURLRequest(url: url, method: method)
            
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader
            }
        }
        return request
    }
}
