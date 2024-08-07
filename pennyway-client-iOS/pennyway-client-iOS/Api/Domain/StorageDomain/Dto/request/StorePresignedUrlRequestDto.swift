
import Foundation

public struct StorePresignedUrlRequestDto: Encodable {
    let algorithm: String
    let credential: String
    let date: String
    let expires: String
    let signature: String
    let signedHeaders: String

    public init(
        algorithm: String,
        credential: String,
        date: String,
        expires: String,
        signature: String,
        signedHeaders: String
    ) {
        self.algorithm = algorithm
        self.credential = credential
        self.date = date
        self.expires = expires
        self.signature = signature
        self.signedHeaders = signedHeaders
    }
}
