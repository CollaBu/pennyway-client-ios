
struct RegistrationManager {
    static var shared = RegistrationManager()

    var name = ""
    var username = ""
    var password = ""
    var phoneNumber = ""
    var formattedPhoneNumber: String? {
        return PhoneNumberFormatter.formattedPhoneNumber(from: phoneNumber)
    }

    var code = ""
    var isFindUsername: Bool = false

    private init() {}

    func performRegistration() {  
        print("Registered User: Name - \(name), UserName - \(username), Phone Number - \(phoneNumber), check FindIdView PhoneVerification - \(isFindUsername)")
    }
}
