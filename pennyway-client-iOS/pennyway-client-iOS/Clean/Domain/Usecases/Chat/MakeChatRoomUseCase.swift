// MARK: - MakeChatRoomUseCase

/// 채팅방 생성 usecase를 정의하는 프로토콜
protocol MakeChatRoomUseCase {
    // 채팅방 생성 기능을 하는 함수
    // - Parameter chatRoomId: 대기 생성 후 반환된 채팅방 ID
    // - Returns: `Bool` 타입으로 성공하면 true, 실패하면 false 반환
    //    func execute(chatRoomId: Int64, completion: @escaping (Bool) -> Void)

    /// 채팅방 생성 대기 기능을 하는 함수
    /// - Returns: `Int64` 타입으로 채팅방 ID 반환
    func pend(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void)
}

// MARK: - DefaultMakeChatRoomUseCase

class DefaultMakeChatRoomUseCase: MakeChatRoomUseCase {
    private let repository: MakeChatRoomRepository

    init(repository: MakeChatRoomRepository) {
        self.repository = repository
    }

    /// 채팅방 대기 생성
    func pend(roomData: MakeChatRoomItemModel, completion: @escaping (Result<Int64, Error>) -> Void) {
        return repository.pendChatRoom(roomData: roomData) { result in
            completion(result)
        }   
    }
}
