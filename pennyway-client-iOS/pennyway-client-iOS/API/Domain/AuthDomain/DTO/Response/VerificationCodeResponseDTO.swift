

import Foundation

struct SMSDTO: Codable {
    let code: String
    let data: SMSData
}

struct SMSData: Codable {
    let sms: SMSDetails
}

struct SMSDetails: Codable {
    let to: String
    let sendAt: String
    let expiresAt: String
}
