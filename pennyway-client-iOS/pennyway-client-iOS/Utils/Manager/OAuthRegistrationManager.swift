
import Foundation

struct OAuthRegistrationManager {
    static var shared = OAuthRegistrationManager()

    var isOAuthRegistration: Bool = false
    var isExistUser: Bool = false
    var isOAuthUser: Bool = false
    var oauthId = ""
    var provider = ""
    var name = ""
    var username = ""
    var password = ""
    var phone = ""
    var formattedPhoneNumber: String? {
        return PhoneNumberFormatter.formattedPhoneNumber(from: phone)
    }

    var code = ""

    private init() {}

    func checkRegistration() {
        print("checkRegistration User: isOAuthRegistration - \(isOAuthRegistration), isExistUser - \(isExistUser), provider - \(provider), name: \(name), username: \(username), phone: \(phone), code: \(code)")
    }
}
