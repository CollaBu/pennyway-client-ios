//
//  ChatRoomViewModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 아우신얀 on 11/5/24.
//

import Combine
import Foundation

// MARK: - ChatRoomViewModelInput

protocol ChatRoomViewModelInput {
    func reset()
    func subscribeToNotifications()
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Bool) -> Void)
    func getPreviousChat(completion: @escaping (Result<Void, Error>) -> Void)
    func sendMessage(message: String, chatRoomId: Int64, contentType: String)
    func deleteChatRoom(chatRoomId: Int64, completion: @escaping (Bool) -> Void)
    func updateAlarmSetting(setting: Bool)
    func deleteChatRoomByAdmin(chatRoomId: Int64, completion: @escaping (Bool) -> Void)
    func updateRoomData(title: String, description: String, backgroundImageUrl: String, isPrivate: Bool) -> ChatRoomProtocol?
}

// MARK: - ChatRoomViewModelOutput

protocol ChatRoomViewModelOutput {
    var roomData: Observable<ChatRoomProtocol?> { get set }
    var roomDetailData: Observable<ChatRoomDetailItemModel?> { get set }
    var messageData: Observable<[MessageItemModel]> { get set }
    var chatUserData: Observable<[ChatMemberItemModel]> { get set }
    var previousMessageData: Observable<PreviousMessage?> { get set }
    var isDeleteSuccessful: Observable<Bool> { get set }
    var isErrorPopupShow: Observable<Bool> { get set }
}

// MARK: - ChatRoomViewModel

protocol ChatRoomViewModel: ChatRoomViewModelInput, ChatRoomViewModelOutput {}

// MARK: - DefaultChatRoomViewModel

class DefaultChatRoomViewModel: ChatRoomViewModel {
    @Published var chatRoomId: Int64 = 0
    @Published var chatMemberId: Int64 = 0
    @Published var isDeleteSuccessful = Observable<Bool>(false)
    @Published var isErrorPopupShow = Observable<Bool>(false)

    var roomData: Observable<ChatRoomProtocol?> = Observable(nil)
    var roomDetailData: Observable<ChatRoomDetailItemModel?> = Observable(nil)
    var messageData: Observable<[MessageItemModel]> = Observable([]) // 메시지 목록
    var chatUserData: Observable<[ChatMemberItemModel]> = Observable([]) // 모든 채팅방 사용자
    var previousMessageData: Observable<PreviousMessage?> = Observable(nil) // 이전 채팅 목록 및 무한 스크롤 데이터

    private let getChatUseCase: GetChatUseCase
    private let sendChatUseCase: SendChatUseCase
    private let chatHistoryList: ChatHistoryList

    private var cancellables = Set<AnyCancellable>()

    init(chatHistoryList: ChatHistoryList = ChatHistoryBinaryList(), chatRoomUseCase: GetChatUseCase, sendChatUseCase: SendChatUseCase) {
        getChatUseCase = chatRoomUseCase
        self.chatHistoryList = chatHistoryList
        self.sendChatUseCase = sendChatUseCase
        self.chatHistoryList.delegate = self
    }

    func reset() {
        roomData.value = nil
        roomDetailData.value = nil
        messageData.value = []
        chatUserData.value = []
        previousMessageData.value = nil
        cancellables.removeAll() // 모든 구독 해제
    }

    /// NotificationCenter에서 메시지 알림 구독
    func subscribeToNotifications() {
        NotificationCenter.default.publisher(for: .didReceiveMessage)
            .sink { [weak self] notification in
                // 메시지 받은 경우 처리
                if let message = notification.object as? MessageItemModel, self?.roomData.value?.id == message.chatRoomId {
                    if message.categoryType == .system {
                        self?.getChatRoomDetail(chatRoomId: message.chatRoomId) { _ in }
                    }
                    self?.handleNewMessage(message)
                    self?.sendLastMessage(chatRoomId: message.chatRoomId, lastReadMessageId: message.chatId)
                }
            }
            .store(in: &cancellables) // 구독 관리
    }

    /// 채팅방 상세 정보 조회
    func getChatRoomDetail(chatRoomId: Int64, completion: @escaping (Bool) -> Void) {
        getChatUseCase.getChatRoomDetail(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case let .success(chatRoomDetail):
                self?.roomDetailData.value = ChatRoomDetailItemModel.from(model: chatRoomDetail)
                if let recentMessages = self?.roomDetailData.value?.recentMessages {
                    self?.messageData.value = recentMessages

                    if !recentMessages.isEmpty {
                        // 마지막 메시지 id 전달
                        self?.sendLastMessage(chatRoomId: chatRoomId, lastReadMessageId: recentMessages[0].chatId)
                    }
                }
                if let recentParticipants = self?.roomDetailData.value?.recentParticipants {
                    if let myInfo = self?.roomDetailData.value?.myInfo {
                        self?.chatUserData.value = [myInfo] + recentParticipants
                        self?.sortChatUserData()
                    }
                }

                if let otherParticipants = self?.roomDetailData.value?.otherParticipants {
                    let ids = otherParticipants.map { $0.id }

                    // ID를 50개씩 나누어 처리
                    for chunk in stride(from: 0, to: ids.count, by: 50) {
                        let chunkedIds = Array(ids[chunk ..< min(chunk + 50, ids.count)])
                        self?.getChatMembers(chatRoomId: chatRoomId, ids: chunkedIds)
                    }
                }
                completion(true)

            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅방 상세 정보 가져오기 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    /// 채팅방 이전 채팅 내역 조회
    func getPreviousChat(completion: @escaping (Result<Void, Error>) -> Void) {
        if let message = messageData.value.last {
            getChatUseCase.getPreviousChat(chatRoomId: message.chatRoomId, lastMessageId: message.chatId) { [weak self] result in
                switch result {
                case let .success(previousMessage):
                    let messages = PreviousMessage.to(model: previousMessage)

                    // 이전 메시지 데이터 업데이트
                    self?.previousMessageData.value = previousMessage
                    self?.handleNewMessages(messages)
                    Log.debug("[DefaultChatRoomViewModel] 이전 채팅 조회 성공: \(previousMessage)")
                    completion(.success(()))

                case let .failure(error):
                    Log.error("[DefaultChatRoomViewModel] 이전 채팅 조회 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }

    /// 채팅 메시지 전송
    /// - Parameters:
    ///   - message: 전송할 메시지 내용.
    ///   - chatRoomId: 채팅방  ID.
    ///   - contentType: 메시지의 콘텐츠 유형.
    func sendMessage(message: String, chatRoomId: Int64, contentType: String) {
        sendChatUseCase.sendMessage(message: message, chatRoomId: chatRoomId, contentType: contentType) { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatRoomViewModel] 채팅 메시지 전송 성공")
            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅 메시지 전송 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 채팅방 나가기
    func deleteChatRoom(chatRoomId: Int64, completion: @escaping (Bool) -> Void) {
        getChatUseCase.deleteChatRoom(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.isDeleteSuccessful.value = true
                    Log.debug("[DefaultChatRoomViewModel] - isDeleteSuccessful: \(self!.isDeleteSuccessful)")
                }

            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅방 삭제 실패: \(error.localizedDescription)")

                switch error {
                case .mismatchConflict:
                    self?.isErrorPopupShow.value = true
                    completion(false)
                case .other, .notAdmin, .notFound:
                    completion(false)
                }
            }
        }
    }

    /// 채팅방장이 채팅방 삭제
    func deleteChatRoomByAdmin(chatRoomId: Int64, completion: @escaping (Bool) -> Void) {
        getChatUseCase.deleteChatRoomByAdmin(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    Log.debug("[DefaultChatRoomViewModel] - isDeleteSuccessful: \(self!.isDeleteSuccessful)")
                }
            case let .failure(error):
                switch error {
                case .notAdmin:
                    self?.isErrorPopupShow.value = true
                    completion(false)

                case .mismatchConflict, .other, .notFound:
                    completion(false)
                }
                Log.error("[DefaultChatRoomViewModel] 채팅방 삭제 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 채팅방 수정 후 데이터 업데이트
    func updateRoomData(title: String, description: String, backgroundImageUrl: String, isPrivate: Bool) -> ChatRoomProtocol? {
        if let room = roomData.value {
            return UpdatedChatRoomModel(
                original: room,
                title: title,
                description: description,
                isPrivate: isPrivate,
                backgroundImageUrl: backgroundImageUrl
            )
        }
        return nil
    }

    /// roomDetailData의 notifiation 여부 update
    func updateAlarmSetting(setting: Bool) {
        roomDetailData.value?.updateAlarmSetting(setting: setting)
    }
}

// MARK: Private Methods

extension DefaultChatRoomViewModel {
    /// 채팅방 멤버 조회
    private func getChatMembers(chatRoomId: Int64, ids: [Int64]) {
        getChatUseCase.getChatMembers(chatRoomId: chatRoomId, ids: ids) { [weak self] result in
            switch result {
            case let .success(members):

                let membersItem = ChatMemberItemModel.from(model: members)
                self?.chatUserData.value += membersItem

                self?.sortChatUserData()
                Log.debug("[DefaultChatRoomViewModel] 채팅방 멤버 조회 성공: \(membersItem)")

            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅방 멤버 조회 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 채팅 마지막으로 읽은 메시지 전송
    private func sendLastMessage(chatRoomId: Int64, lastReadMessageId: Int64) {
        sendChatUseCase.sendLastMessage(chatRoomId: chatRoomId, lastReadMessageId: lastReadMessageId) { result in
            switch result {
            case .success:
                Log.debug("[DefaultChatRoomViewModel] 채팅 마지막으로 읽은 메시지 전송 성공")
            case let .failure(error):
                Log.error("[DefaultChatRoomViewModel] 채팅 마지막으로 읽은 메시지 전송 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 단일 메시지 삽입
    private func handleNewMessage(_ message: MessageItemModel) {
        chatHistoryList.insert(message, true)
    }

    /// 여러 메시지 삽입
    private func handleNewMessages(_ messages: [MessageItemModel]) {
        chatHistoryList.insertMessages(messages)
    }

    /// 채팅방 사용자 정렬
    private func sortChatUserData() {
        guard let currentUser = getUserData() else {
            return
        }

        guard !chatUserData.value.isEmpty else {
            return
        }

        // 0번째 인덱스(현재 사용자) 따로 저장
        let firstElement = chatUserData.value[0]

        // 나머지 요소들만 정렬
        let sortedRest = chatUserData.value.dropFirst().sorted { (lhs: ChatMemberItemModel, rhs: ChatMemberItemModel) -> Bool in
            // 다른 사용자가 Admin이면 두 번째 우선순위
            if lhs.role == .admin, lhs.id != currentUser.id {
                return true
            }
            if rhs.role == .admin, rhs.id != currentUser.id {
                return false
            }

            // 나머지는 이름 순 정렬
            return lhs.name < rhs.name
        }

        // 0번째 요소를 맨 앞에 두고 나머지 정렬된 배열을 이어붙임
        chatUserData.value = [firstElement] + sortedRest
    }
}

// MARK: ChatHistoryDelegate

extension DefaultChatRoomViewModel: ChatHistoryDelegate {
    func didAddChatHistory(_ messages: [MessageItemModel]) {
        messageData.value.insert(contentsOf: messages, at: 0)
    }

    func didAddChatHistories(_ messages: [MessageItemModel]) {
        messageData.value.append(contentsOf: messages)
    }
}
