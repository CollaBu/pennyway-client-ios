

import Alamofire
import Foundation

enum AuthRouter: URLRequestConvertible {
    case regist(username: String, name: String, password: String, phone: String, code: String)
    case sendVerificationCode(phone: String)
    case verifyVerificationCode(phone: String, code: String)
    case checkDuplicateUserName(username: String)
    case login(username: String, password: String)
    case linkExistingAccountToOAuth(password: String, phone: String, code: String)

    var method: HTTPMethod {
        switch self {
        case .regist, .sendVerificationCode, .verifyVerificationCode, .login, .linkExistingAccountToOAuth:
            return .post
        case .checkDuplicateUserName:
            return .get
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .regist:
            return "v1/auth/sign-up"
        case .sendVerificationCode:
            return "v1/auth/phone"
        case .verifyVerificationCode:
            return "v1/auth/phone/verification"
        case .checkDuplicateUserName:
            return "v1/duplicate/username"
        case .login:
            return "v1/auth/sign-in"
        case .linkExistingAccountToOAuth:
            return "v1/auth/link-oauth"
        }
    }

    var parameters: Parameters {
        switch self {
        case let .regist(username, name, password, phone, code):
            return ["username": username, "name": name, "password": password, "phone": phone, "code": code]
        case let .sendVerificationCode(phone):
            return ["phone": phone]
        case let .verifyVerificationCode(phone, code):
            return ["phone": phone, "code": code]
        case .checkDuplicateUserName:
            return [:]
        case let .login(username, password):
            return ["username": username, "password": password]
        case let .linkExistingAccountToOAuth(password, phone, code):
            return ["password": password, "phone": phone, "code": code]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .regist, .sendVerificationCode, .verifyVerificationCode, .login, .linkExistingAccountToOAuth:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)

        case let .checkDuplicateUserName(username):
            let queryParameters = [URLQueryItem(name: "username", value: username)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        }
        return request
    }
}
