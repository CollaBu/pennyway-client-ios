
struct RegistrationManager {
    static var shared = RegistrationManager()

    var name: String?
    var id: String?
    var password: String?
    var phoneNumber: String?
    var formattedPhoneNumber: String? {
        guard let phoneNumber = phoneNumber else {
            return nil
        }
        let areaCode = String(phoneNumber.prefix(3))
        let middlePart = String(phoneNumber.dropFirst(3).prefix(4))
        let lastPart = String(phoneNumber.dropFirst(7))
        return "\(areaCode)-\(middlePart)-\(lastPart)"
    }

    var verificationCode: String?

    /// Singleton 패턴을 위한 private 생성자
    private init() {}

    func performRegistration() {
        if let name = name, let id = id, let password = password, let phoneNumber = formattedPhoneNumber, let verificationCode = verificationCode {
            print("Registered User: Name - \(name), ID - \(id), Password - \(password), Phone Number - \(phoneNumber), Verification Code - \(verificationCode)")
        } else {
            print("Missing information for registration")
        }
    }
}
