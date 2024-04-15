

import Foundation

public struct SignUpRequestDTO: Encodable {
    let username: String
    let name: String
    let password: String
    let phone: String
    let code: String
    
    public init(
        username: String,
        name: String,
        password: String,
        phone: String,
        code: String
    ) {
        self.username = username
        self.name = name
        self.password = password
        self.phone = phone
        self.code = code
    }
}
