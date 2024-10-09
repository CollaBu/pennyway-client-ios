
struct RegistrationManager {
    static var shared = RegistrationManager()

    var name = ""
    var username = ""
    var oldPassword = ""
    var password = ""
    var phoneNumber = ""
    var formattedPhoneNumber: String? {
        return PhoneNumberFormatterUtil.formatPhoneNumber(from: phoneNumber)
    }

    var code = ""

    private init() {}

    func performRegistration() {  
        print("Registered User: Name - \(name), UserName - \(username), Phone Number - \(phoneNumber)")
    }
}
