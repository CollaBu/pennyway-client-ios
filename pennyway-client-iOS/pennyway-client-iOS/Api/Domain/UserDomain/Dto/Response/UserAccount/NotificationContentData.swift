import Foundation

struct NotificationContentData: Codable, Identifiable {
    let id: Int
    let isRead: Bool
    let title: String
    let content: String   
    let type: String
    let from: String?
    let fromId: Int?
    let toId: Int?
    let createdAt: String 
}
