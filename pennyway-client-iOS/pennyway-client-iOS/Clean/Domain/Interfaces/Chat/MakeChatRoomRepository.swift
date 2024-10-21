
import Foundation

/// 채팅방 생성 동작을 정의하는 프로토콜
protocol MakeChatRoomRepository {
    /// 채팅방 생성하는 함수
    func makeChatRoom(roomData: MakeChatRoomItemModel, completion: @escaping (Result<MakeChatRoomResponseDto, Error>) -> Void)
}
