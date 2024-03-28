
struct RegistrationManager {
    static var shared = RegistrationManager()

    var name: String?
    var id: String?
    var password: String?
    var phoneNumber: String?
    var verificationCode: String?

    // Singleton 패턴을 위한 private 생성자
    private init() {}

    mutating func addInput(name: String? = nil, id: String? = nil, password: String? = nil, phoneNumber: String? = nil, verificationCode: String? = nil) {
        self.name = name
        self.id = id
        self.password = password
        self.phoneNumber = phoneNumber
        self.verificationCode = verificationCode
    }

    func performRegistration() {
        if let name = name, let id = id, let password = password, let phoneNumber = phoneNumber, let verificationCode = verificationCode {
            print("Registered User: Name - \(name), ID - \(id), Password - \(password), Phone Number - \(phoneNumber), Verification Code - \(verificationCode)")
        } else {
            print("Missing information for registration")
        }
    }
}
