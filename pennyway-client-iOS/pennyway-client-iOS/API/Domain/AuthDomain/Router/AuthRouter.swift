

import Alamofire
import Foundation

enum AuthRouter: URLRequestConvertible {
    case signup(dto: SignUpRequestDTO)
    case receiveVerificationCode(dto: VerificationCodeRequestDTO)
    case verifyVerificationCode(dto: VerificationRequestDTO)
    case checkDuplicateUserName(dto: DuplicateCheckRequestDTO)
    case login(dto: LoginRequestDTO)
    case linkAccountToExistingOAuth(dto: LinkAccountToOAuthRequestDTO)

    var method: HTTPMethod {
        switch self {
        case .signup, .receiveVerificationCode, .verifyVerificationCode, .login, .linkAccountToExistingOAuth:
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
        case .linkAccountToExistingOAuth:
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
            return try? dto.asDictionary()
        case let .login(dto):
            return try? dto.asDictionary()
        case let .linkAccountToExistingOAuth(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .signup, .verifyVerificationCode, .login, .linkAccountToExistingOAuth:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)

        case .receiveVerificationCode:
            let queryParameters = [URLQueryItem(name: "type", value: "general")]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case let .checkDuplicateUserName(dto):
            let queryParameters = [URLQueryItem(name: "username", value: dto.username)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        }
        return request
    }
}
