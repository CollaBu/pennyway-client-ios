
import Alamofire
import Foundation

enum UserAccountRouter: URLRequestConvertible {
    case getUserProfile
    case deleteUserAccount
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile:
            return .get
        case .deleteUserAccount:
            return .delete
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getUserProfile, .deleteUserAccount:
            return "v2/users/me"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUserProfile, .deleteUserAccount:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getUserProfile, .deleteUserAccount:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
