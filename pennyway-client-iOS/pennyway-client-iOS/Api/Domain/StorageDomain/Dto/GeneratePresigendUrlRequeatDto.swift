
import Foundation

public struct GeneratePresigendUrlRequeatDto: Encodable {
    let type: String
    let ext: String

    public init(
        type: String,
        ext: String
    ) {
        self.type = type
        self.ext = ext
    }
}
