
import Foundation

enum PhoneNumberFormatter {
    static func formattedPhoneNumber(from phoneNumber: String?) -> String? {
        guard let phoneNumber = phoneNumber else {
            return nil
        }
        let areaCode = String(phoneNumber.prefix(3))
        let middlePart = String(phoneNumber.dropFirst(3).prefix(4))
        let lastPart = String(phoneNumber.dropFirst(7))
        return "\(areaCode)-\(middlePart)-\(lastPart)"
    }
}