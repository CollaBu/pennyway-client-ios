

import Alamofire
import Foundation

enum AuthRouter: URLRequestConvertible {
    case signup(dto: SignUpRequestDto)
    case receiveVerificationCode(dto: VerificationCodeRequestDto)
    case verifyVerificationCode(dto: VerificationRequestDto)
    case checkDuplicateUserName(dto: CheckDuplicateRequestDto)
    case login(dto: LoginRequestDto)
    case linkAccountToOAuth(dto: LinkAccountToOAuthRequestDto)
    case findUserName(dto: FindUserNameRequestDto)
    case receiveUserNameVerificationCode(dto: VerificationCodeRequestDto)
    case receivePwVerificationCode(dto: VerificationCodeRequestDto)
    case logout
    case requestResetPw(dto: RequestResetPwDto)
    case receivePwVerifyVerificationCode(dto: VerificationRequestDto)
    
    var method: HTTPMethod {
        switch self {
        case .signup, .receiveVerificationCode, .verifyVerificationCode, .login, .linkAccountToOAuth, .receiveUserNameVerificationCode, .receivePwVerificationCode, .receivePwVerifyVerificationCode:
            return .post
        case .checkDuplicateUserName, .findUserName, .logout:
            return .get
        case .requestResetPw:  
            return .patch
        }
    }
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "v1/auth/sign-up"
        case .receiveVerificationCode, .receiveUserNameVerificationCode, .receivePwVerificationCode:
            return "v1/phone"
        case .verifyVerificationCode:
            return "v1/auth/phone/verification"
        case .checkDuplicateUserName:
            return "v1/duplicate/username"
        case .login:
            return "v1/auth/sign-in"
        case .linkAccountToOAuth:
            return "v1/auth/link-oauth"
        case .findUserName:
            return "v1/find/username"
        case .logout:
            return "v1/sign-out"
        case .requestResetPw:
            return "v1/find/password"
        case .receivePwVerifyVerificationCode:
            return "v1/find/password/verification"
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
        case let .receiveUserNameVerificationCode(dto):
            return try? dto.asDictionary()
        case let .receivePwVerificationCode(dto):
            return try? dto.asDictionary()
        case .checkDuplicateUserName:
            return [:]
        case let .login(dto):
            return try? dto.asDictionary()
        case let .linkAccountToOAuth(dto):
            return try? dto.asDictionary()
        case let .findUserName(dto):
            return try? dto.asDictionary()
        case .logout:
            return [:]
            
        case let .requestResetPw(dto):
            return try? dto.asDictionary()
        case let .receivePwVerifyVerificationCode(dto):
            return try? dto.asDictionary()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .signup, .verifyVerificationCode, .login, .linkAccountToOAuth, .receivePwVerifyVerificationCode, .requestResetPw:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
            
        case let .receiveVerificationCode:
            let queryParameters = [URLQueryItem(name: "type", value: "general")]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case let .receiveUserNameVerificationCode: // 아이디 찾기 번호 인증
            let queryParameters = [URLQueryItem(name: "type", value: "username")]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case let .receivePwVerificationCode:
            let queryParameters = [URLQueryItem(name: "type", value: "password")]
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters, queryParameters: queryParameters)
            
        case let .checkDuplicateUserName(dto):
            let queryParameters = [URLQueryItem(name: "username", value: dto.username)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
            
        case let .findUserName(dto):
            let queryParameters = [URLQueryItem(name: "phone", value: dto.phone), URLQueryItem(name: "code", value: dto.code)]
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
            
        case .logout:
            request = URLRequest.createURLRequest(url: url, method: method)
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader
            }
            let accessToken = KeychainHelper.loadAccessToken() ?? ""
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            
//        case let .requestResetPw(dto):
//            let queryParameters = [URLQueryItem(name: "phone", value: dto.phone), URLQueryItem(name: "code", value: dto.code), URLQueryItem(name: "newPassword", value: dto.newPassword)]
//            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        }
        return request
    }
}
