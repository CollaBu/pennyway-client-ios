
import SwiftUI

class PresignedUrlViewModel: ObservableObject {
    /// presigned url 발급
    func generatePresignedUrlApi(completion: @escaping (Bool) -> Void) {
        let generatePresigendUrlRequestDto = GeneratePresigendUrlRequestDto(type: ImageType.profile.rawValue, ext: Ext.jpg.rawValue)

        StorageAlamofire.shared.generatePresignedUrl(generatePresigendUrlRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("presigned_url 발급 성공 \(jsonString)")
                    }
                    completion(true)
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}
