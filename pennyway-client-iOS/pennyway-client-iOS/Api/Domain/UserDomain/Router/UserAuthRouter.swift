
import Alamofire
import Foundation

enum UserAuthRouter: URLRequestConvertible {
    case linkOAuthAccount(dto: OAuthUserData)
    case unlinkOAuthAccount
    
    var method: HTTPMethod {
        switch self {
        case .linkOAuthAccount:
            return .put
        case .unlinkOAuthAccount:
            return .delete
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .linkOAuthAccount:
            return "v1/link-oauth"
        case .unlinkOAuthAccount:
            return "v1/link-oauth"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .linkOAuthAccount(dto):
            return try? dto.asDictionary()
        case .unlinkOAuthAccount:
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
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
