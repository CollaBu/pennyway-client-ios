
import Foundation

struct Chat: Equatable, Identifiable {
    let id: Int64
    let content: String
    let created_at: String
    let sender_id: Int64
    let chat_room_id: Int64
}

