import Foundation

// MARK: - GetNotificationResponseDto

struct GetNotificationResponseDto: Codable {
    let code: String
    let data: NotificationsData

    struct NotificationsData: Codable {
        let notifications: NotificationsPage
    }
}

// MARK: - NotificationsPage

struct NotificationsPage: Codable {
    let content: [NotificationContentData]
    let currentPageNumber: Int
    let pageSize: Int
    let numberOfElements: Int
    let hasNext: Bool
}
