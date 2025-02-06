//
//  DefaultShareToChatRoomRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 2/4/25.
//

import Foundation

class DefaultShareToChatRoomRepository: ShareToChatRoomRepository {
    func shareToChatRoom(date: Date, chatRoomIds: [Int64], completion: @escaping (Bool) -> Void) {
        let dto = ShareSpendingHistoryRequestDto(type: "CHAT_ROOM", year: Date.year(from: date), month: Date.month(from: date), day: Date.day(from: date), chatRoomIds: chatRoomIds)

        Log.debug("DefaultShareToChatRoomRepository: \(dto)")

        SpendingAlamofire.shared.shareSpendingHistory(dto: dto) { result in
            switch result {
            case .success:
                Log.debug("[DefaultShareToChatRoomRepository]: 지출 내역 채팅방 공유 성공")
                completion(true)
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}
