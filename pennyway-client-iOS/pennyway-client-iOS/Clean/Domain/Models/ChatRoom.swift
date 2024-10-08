
import Foundation

struct ChatRoom: Equatable, Identifiable {
    let id: Int64
    let title: String
    let description: String
    let background_image_url: String
    let password: String // 미정 수정필요
    let privacy_setting: Bool
    let notify_setting: Bool
}
