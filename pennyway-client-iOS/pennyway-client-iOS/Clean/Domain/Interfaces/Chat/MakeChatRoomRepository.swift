
import Foundation

/// 채팅방 생성 동작을 정의하는 프로토콜
protocol MakeChatRoomRepository {
    // 채팅방 생성하는 함수
//    func makeChatRoom(completion: @escaping (Bool) -> Void)

    /// 채팅방 생성 대기하는 함수
    func pendChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void)
}
