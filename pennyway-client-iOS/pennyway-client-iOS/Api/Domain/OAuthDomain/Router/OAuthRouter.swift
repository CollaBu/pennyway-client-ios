
import Alamofire
import Foundation

enum OAuthRouter: URLRequestConvertible {
    case oauthLogin(dto: OAuthLoginRequestDto)
    case oauthReceiveVerificationCode(dto: OAuthVerificationCodeRequestDto, type: VerificationType)
    case oauthVerifyVerificationCode(dto: OAuthVerificationRequestDto)
    case linkOAuthToAccount(dto: LinkOAuthToAccountRequestDto)
    case oauthSignUp(dto: OAuthSignUpRequestDto)

    var method: HTTPMethod {
        switch self {
        case .oauthLogin, .oauthReceiveVerificationCode, .oauthVerifyVerificationCode, .linkOAuthToAccount, .oauthSignUp:
            return .post
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .oauthLogin:
            return "v1/auth/oauth/sign-in"
        case .oauthReceiveVerificationCode:
            return "v1/phone"
        case .oauthVerifyVerificationCode:
            return "v1/auth/oauth/phone/verification"
        case .linkOAuthToAccount:
            return "v1/auth/oauth/link-auth"
        case .oauthSignUp:
            return "v1/auth/oauth/sign-up"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .oauthLogin(dto):
            return try? dto.asDictionary()
        case let .oauthReceiveVerificationCode(dto, _):
            return try? dto.asDictionary()
        case let .oauthVerifyVerificationCode(dto):
            return try? dto.asDictionary()
        case let .linkOAuthToAccount(dto):
            return try? dto.asDictionary()
        case let .oauthSignUp(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case let .oauthLogin(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthVerifyVerificationCode(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .linkOAuthToAccount(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthReceiveVerificationCode(dto, type):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider), URLQueryItem(name: "type", value: type.rawValue)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        case let .oauthSignUp(dto):
            let queryParameters = [URLQueryItem(name: "provider", value: dto.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
        }
        return request
    }
}
