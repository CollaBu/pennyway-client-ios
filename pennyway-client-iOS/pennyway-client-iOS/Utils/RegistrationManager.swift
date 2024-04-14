
struct RegistrationManager {
    static var shared = RegistrationManager()

    var name: String?
    var username: String?
    var password: String?
    var phoneNumber: String?
    var formattedPhoneNumber: String? {
        return PhoneNumberFormatter.formattedPhoneNumber(from: phoneNumber)
    }

    var verificationCode: String?

    private init() {}

    func performRegistration() {
        if let name = name, let username = username, let password = password, let phoneNumber = formattedPhoneNumber, let verificationCode = verificationCode {
            print("Registered User: Name - \(name), UserName - \(username), Password - \(password), Phone Number - \(phoneNumber), Verification Code - \(verificationCode)")
        } else {
            print("Missing information for registration")
        }
    }
}
