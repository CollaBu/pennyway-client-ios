
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

    func toQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "X-Amz-Algorithm", value: algorithm),
            URLQueryItem(name: "X-Amz-Date", value: date),
            URLQueryItem(name: "X-Amz-SignedHeaders", value: signedHeaders),
            URLQueryItem(name: "X-Amz-Credential", value: credential),
            URLQueryItem(name: "X-Amz-Expires", value: expires),
            URLQueryItem(name: "X-Amz-Signature", value: signature)
        ]
    }
}
