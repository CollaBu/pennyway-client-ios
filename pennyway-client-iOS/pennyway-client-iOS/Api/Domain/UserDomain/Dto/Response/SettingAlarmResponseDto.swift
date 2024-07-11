
import Foundation

// MARK: - SettingAlarmResponseDto

struct SettingAlarmResponseDto: Codable {
    let code: String
    let data: NotifySettingData
}

// MARK: - NotifySettingWrapper

struct NotifySettingWrapper: Codable {
    let notifySetting: NotifySettingData
}

// MARK: - NotifySettingData

struct NotifySettingData: Codable {
    let accountBookNotify: Bool?
    let chatNotify: Bool?
    let feedNotify: Bool?
}
