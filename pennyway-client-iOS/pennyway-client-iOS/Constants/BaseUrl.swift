
import Foundation

// MARK: - API

enum API {
    static let BASE_URL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        return baseURL.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "")
    }()
}
