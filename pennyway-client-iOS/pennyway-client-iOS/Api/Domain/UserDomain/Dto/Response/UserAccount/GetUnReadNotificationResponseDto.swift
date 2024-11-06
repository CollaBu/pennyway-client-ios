//
//  GetUnReadNotificationResponseDto.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

import Foundation

// MARK: - GetUnReadNotificationResponseDto

struct GetUnReadNotificationResponseDto: Codable {
    let code: String
    let data: UnReadNotificationsData
}

// MARK: - UnReadNotificationsData

struct UnReadNotificationsData: Codable {
    let notifications: [NotificationContentData]
}
