
import Foundation

struct OAuthRegistrationManager {
    static var shared = OAuthRegistrationManager()

    var isOAuthRegistration: Bool = false
    var isExistUser: Bool = true

    private init() {}

    func checkRegistration() {
        print("checkRegistration User: isOAuthRegistration - \(isOAuthRegistration), isExistUser - \(isExistUser)")
    }
}
