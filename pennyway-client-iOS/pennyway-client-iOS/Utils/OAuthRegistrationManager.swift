
import Foundation

struct OAuthRegistrationManager {
    static var shared = OAuthRegistrationManager()

    var isOAuthRegistration: Bool = false
    var isExistUser: Bool = true

    private init() {}

    func checkRegistration() {
        // if let isLoggedIn = isLoggedIn{
        print("checkRegistration User: isOAuthRegistration - \(isOAuthRegistration), isExistUser - \(isExistUser)")
        //  } else {
        // print("Missing information for registration")
        //  }
    }
}
