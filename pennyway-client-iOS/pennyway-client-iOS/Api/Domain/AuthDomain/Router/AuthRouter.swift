

import Alamofire
import Foundation

enum AuthRouter: URLRequestConvertible {
    case signup(dto: SignUpRequestDto)
    case receiveVerificationCode(dto: VerificationCodeRequestDto)
    case verifyVerificationCode(dto: VerificationRequestDto)
    case checkDuplicateUserName(dto: CheckDuplicateRequestDto)
    case login(dto: LoginRequestDto)
    case linkAccountToOAuth(dto: LinkAccountToOAuthRequestDto)

    var method: HTTPMethod {
        switch self {
        case .signup, .receiveVerificationCode, .verifyVerificationCode, .login, .linkAccountToOAuth:
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
        case .signup:
            return "v1/auth/sign-up"
        case .receiveVerificationCode:
            return "v1/phone"
        case .verifyVerificationCode:
            return "v1/auth/phone/verification"
        case .checkDuplicateUserName:
            return "v1/duplicate/username"
        case .login:
            return "v1/auth/sign-in"
        case .linkAccountToOAuth:
            return "v1/auth/link-oauth"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .signup(dto):
            return try? dto.asDictionary()
        case let .receiveVerificationCode(dto):
            return try? dto.asDictionary()
        case let .verifyVerificationCode(dto):
            return try? dto.asDictionary()
        case let .checkDuplicateUserName(dto):
            return [:]
        case let .login(dto):
            return try? dto.asDictionary()
        case let .linkAccountToOAuth(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .signup, .verifyVerificationCode, .login, .linkAccountToOAuth:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)

        case .receiveVerificationCode:
            let queryParameters = [URLQueryItem(name: "type", value: "general")]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)

        case let .checkDuplicateUserName(dto):
            let queryParameters = [URLQueryItem(name: "username", value: dto.username)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        }
        return request
    }
}
