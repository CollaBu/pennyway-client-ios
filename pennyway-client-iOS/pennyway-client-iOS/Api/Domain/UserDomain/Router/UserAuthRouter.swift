
import Alamofire
import Foundation

enum UserAuthRouter: URLRequestConvertible {
    case linkOAuthAccount(dto: OAuthUserData)
    case unlinkOAuthAccount, checkLoginState

    var method: HTTPMethod {
        switch self {
        case .linkOAuthAccount:
            return .put
        case .unlinkOAuthAccount:
            return .delete
        case .checkLoginState:
            return .get
        }
    }

    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }

    var path: String {
        switch self {
        case .linkOAuthAccount, .unlinkOAuthAccount:
            return "v1/link-oauth"
        case .checkLoginState:
            return "v1/auth"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .linkOAuthAccount(dto):
            return try? dto.asDictionary()
        case .unlinkOAuthAccount, .checkLoginState:
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
            let queryParameters = [URLQueryItem(name: "provider", value: OAuthRegistrationManager.shared.provider)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)

        case .checkLoginState:
            request = URLRequest.createURLRequest(url: url, method: method)
        }
        return request
    }
}
