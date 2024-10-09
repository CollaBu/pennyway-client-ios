
import SwiftUI

// MARK: - AlarmList

struct AlarmList: Identifiable {
    let id = UUID()
    let message: String
    let date: String
    let isRead: Bool
}

let dummyAlarms = [
    AlarmList(message: "수민님이 나를 팔로우하기 시작했어요", date: "오늘", isRead: false),
    AlarmList(message: "수민님이 나를 팔로우하기 시작했어요", date: "오늘", isRead: false),
    AlarmList(message: "수민님이 나를 팔로우하기 시작했어요", date: "어제", isRead: true),
    AlarmList(message: "수민님이 나를 팔로우하기 시작했어요", date: "어제", isRead: true),
    AlarmList(message: "수민님이 나를 팔로우하기 시작했어요", date: "어제", isRead: true)
]
