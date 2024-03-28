

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {

    case regist(username: String, name: String, password: String)
    case sendVerificationCode(phone: String)
    case verifyVerificationCode(phone: String, code: String)
    
    var method: HTTPMethod {
        switch self {
        case .regist, .sendVerificationCode, .verifyVerificationCode:
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
        case .sendVerificationCode:
            return "v1/auth/send"
        case .verifyVerificationCode:
            return "v1/auth/code"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .regist(username, name, password):
            return ["username": username, "name": name, "password": password]
        case let .sendVerificationCode(phone):
            return ["phone": phone]
        case let .verifyVerificationCode(phone, code):
            return ["phone": phone, "code": code]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .regist(let username, let name , let password):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        
        case .sendVerificationCode(let phone):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        case .verifyVerificationCode(let phone, let code):
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        }
        return request
    }
}
