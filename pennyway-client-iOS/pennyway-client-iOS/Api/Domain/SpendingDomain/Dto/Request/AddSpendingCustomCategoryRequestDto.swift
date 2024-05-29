
import Foundation

public struct AddSpendingCustomCategoryRequestDto: Encodable {
    let name: String
    let icon: String

    public init(
        name: String,
        icon: String
    ) {
        self.name = name
        self.icon = icon
    }
}
