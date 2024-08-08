
import Foundation

public struct StorePresignedUrlRequestDto: Encodable {
    let algorithm: String
    let date: String
    let signedHeaders: String
    let credential: String
    let expires: String
    let signature: String

    public init(
        algorithm: String,
        date: String,
        signedHeaders: String,
        credential: String,
        expires: String,
        signature: String
    ) {
        self.algorithm = algorithm
        self.date = date
        self.signedHeaders = signedHeaders
        self.credential = credential
        self.expires = expires
        self.signature = signature
    }
}
