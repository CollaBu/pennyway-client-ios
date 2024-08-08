
import Alamofire
import Foundation

enum UserAccountRouter: URLRequestConvertible {
    case getUserProfile
    case deleteUserAccount
    case registDeviceToken(dto: FcmTokenDto)
    case settingOnAlarm(type: String)
    case settingOffAlarm(type: String)
    case validatePw(dto: ValidatePwRequestDto)
    case resetMyPw(dto: ResetMyPwRequestDto)
    case editUserId(dto: CheckDuplicateRequestDto)
    case editUserPhoneNumber(dto: VerificationRequestDto)
    case editUserName(dto: EditNameRequestDto)
    case getNotificationList(dto: GetNotificationRequestDto)
    case uploadProfileImage(dto: UploadProfileImageRequestDto)
    case readNotifications(dto: ReadNotificationsRequestDto)
    case checkUnReadNotifications
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile, .getNotificationList, .checkUnReadNotifications:
            return .get
        case .deleteUserAccount, .settingOffAlarm:
            return .delete
        case .registDeviceToken, .uploadProfileImage:
            return .put
        case .settingOnAlarm, .resetMyPw, .editUserId, .editUserPhoneNumber, .editUserName, .readNotifications:
            return .patch
        case .validatePw:
            return .post
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
        case .settingOnAlarm, .settingOffAlarm:
            return "v2/users/me/notifications"
        case .validatePw:
            return "v2/users/me/password/verification"
        case .resetMyPw:
            return "v2/users/me/password"
        case .editUserId:
            return "v2/users/me/username"
        case .editUserPhoneNumber:
            return "v2/users/me/phone"
        case .editUserName:
            return "v2/users/me/name"
        case .getNotificationList, .readNotifications:
            return "v2/notifications"
        case .uploadProfileImage:
            return "v2/users/me/profile-image"
        case .checkUnReadNotifications:
            return "v2/notifications/unread"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUserProfile, .deleteUserAccount, .checkUnReadNotifications:
            return [:]
        case let .registDeviceToken(dto):
            return try? dto.asDictionary()
        case let .validatePw(dto):
            return try? dto.asDictionary()
        case let .resetMyPw(dto):
            return try? dto.asDictionary()
        case let .settingOnAlarm(type), let .settingOffAlarm(type):
            return ["type": type]
        case let .editUserId(dto):
            return try? dto.asDictionary()
        case let .editUserPhoneNumber(dto):
            return try? dto.asDictionary()
        case let .editUserName(dto):
            return try? dto.asDictionary()
        case let .getNotificationList(dto):
            return try? dto.asDictionary()
        case let .uploadProfileImage(dto):
            return try? dto.asDictionary()
        case let .readNotifications(dto):
            return try? dto.asDictionary()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        case .getUserProfile, .deleteUserAccount, .checkUnReadNotifications:
            request = URLRequest.createURLRequest(url: url, method: method)
        case .registDeviceToken, .validatePw, .resetMyPw, .editUserId, .editUserPhoneNumber, .editUserName, .readNotifications, .uploadProfileImage:
            request = URLRequest.createURLRequest(url: url, method: method, bodyParameters: parameters)
        case .settingOnAlarm, .settingOffAlarm, .getNotificationList:
            let queryParameters = parameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request = URLRequest.createURLRequest(url: url, method: method, queryParameters: queryParameters)
        }
        return request
    }
}
