import Foundation

// MARK: - CheckUnReadNotificationResponseDto

struct CheckUnReadNotificationResponseDto: Codable {
    let code: String
    let data: NotificationsData
}

// MARK: - NotificationsData

struct NotificationsData: Codable {
    let hasUnread: Bool
}
