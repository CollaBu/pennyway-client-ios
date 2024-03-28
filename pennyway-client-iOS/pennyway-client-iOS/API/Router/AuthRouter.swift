

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {

    case regist(username: String, name: String, password: String)
    case sendSms(phone: String)
    
    var method: HTTPMethod {
        switch self {
        case .regist, .sendSms:
            return .post
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .regist:
            return "v1/auth/register"
        case .sendSms:
            return "v1/auth/send_sms"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .regist(username, name, password):
            return ["username": username, "name": name, "password": password]
        case let .sendSms(phone):
            return ["phone": phone]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .regist(let username, let name , let password):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        
        case .sendSms(let phone):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
