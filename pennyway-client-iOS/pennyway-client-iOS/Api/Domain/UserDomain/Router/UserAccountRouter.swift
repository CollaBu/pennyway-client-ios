
import Alamofire
import Foundation

enum UserAccountRouter: URLRequestConvertible {
    case getUserProfile
    case deleteUserAccount
    case registDeviceToken(dto: FcmTokenDto)
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile:
            return .get
        case .deleteUserAccount:
            return .delete
        case .registDeviceToken:
            return .put
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getUserProfile, .deleteUserAccount:
            return "v2/users/me"
        case .registDeviceToken:
            return "v2/users/me/device-tokens"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUserProfile, .deleteUserAccount:
            return [:]
        case let .registDeviceToken(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getUserProfile, .deleteUserAccount:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .registDeviceToken:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
