
import Foundation

public struct GeneratePresigendUrlRequestDto: Encodable {
    let type: String
    let ext: String

    private init(
        type: String,
        ext: String
    ) {
        self.type = type
        self.ext = ext
    }

    static func from(model: PresignedUrlType) -> GeneratePresigendUrlRequestDto {
        return GeneratePresigendUrlRequestDto.init(type: model.type, ext: model.ext)
    }
}
