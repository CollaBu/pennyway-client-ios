
import Alamofire
import Foundation

enum UserAuthRouter: URLRequestConvertible {
    case linkOAuthAccount(dto: OAuthUserData)
    
    var method: HTTPMethod {
        switch self {
        case .linkOAuthAccount:
            return .put
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .linkOAuthAccount:
            return "v1/link-oauth"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .linkOAuthAccount(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .linkOAuthAccount:
            let queryParameters = [URLQueryItem(name: "provider", value: OAuthRegistrationManager.shared.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
