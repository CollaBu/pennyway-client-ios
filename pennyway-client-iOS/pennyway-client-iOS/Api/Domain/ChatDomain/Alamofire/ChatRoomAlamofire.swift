//
//  ChatRoomAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/5/24.
//

import Alamofire

class ChatRoomAlamofire {
    static let shared = ChatRoomAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    /// 채팅방 생성
    func getChatRoomDetail(_ chatRoomId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getChatRoomDetail() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getChatRoomDetail(chatRoomId: chatRoomId), completion: completion)
    }
    
    /// 채팅 이력 조회
    func getPreviousChat(_ chatRoomId: Int64, _ dto: GetPreviousChatRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getPreviousChat() called \(chatRoomId) \(dto.lastMessageId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getPreviousChat(chatRoomId: chatRoomId, dto: dto), completion: completion)
    }
    
    /// 채팅 멤버 조회
    func getChatMembers(_ chatRoomId: Int64, _ dto: GetChatMembersRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getChatMembers() called \(chatRoomId) ")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getChatMembers(chatRoomId: chatRoomId, dto: dto), completion: completion)
    }
    
    /// 채팅방 나가기
    func deleteChatRoom(_ chatRoomId: Int64, _ chatMemberId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - deleteChatRoom() called \(chatRoomId),\(chatMemberId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.deleteChatRoom(chatRoomId: chatRoomId, chatMemberId: chatMemberId), completion: completion)
    }
}
