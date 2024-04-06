
import Foundation

struct OAuthRegistrationManager {
    static var shared = OAuthRegistrationManager()

    var isLoggedIn: Bool?

    private init() {}

    func checkRegistration() {
        if let isLoggedIn = isLoggedIn{
            print("checkRegistration User: isLoggedIn - \(isLoggedIn)")
        } else {
            print("Missing information for registration")
        }
    }
}
