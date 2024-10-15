

import Foundation

class DefaultMakeChatRoomRepository: MakeChatRoomRepository {
    /// 채팅방 생성 대기 api
    func pendChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void) {
        let pendChatRoomRequestDto = PendChatRoomRequestDto(title: roomData.title, description: roomData.description, password: roomData.password)

        ChatAlamofire.shared.pendChatRoom(pendChatRoomRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(PendChatRoomResponseDto.ChatRoomData.self, from: responseData)
                        Log.debug("[DefaultMakeChatRoomRepository]: 채팅방 생성 대기 api 성공: \(response)")
                        completion(.success(response.chatRoomId))
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(.failure(error))
            }
        }
    }
}
