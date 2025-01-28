//
//  ChatRoomAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 최희진, 신얀 on 11/5/24.
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
    
    /// 채팅방 정보 조회
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
    func deleteChatRoom(_ chatRoomId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - deleteChatRoom() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.deleteChatRoom(chatRoomId: chatRoomId), completion: completion)
    }
    
    /// 채팅방 멤버 강제추방
    func banChatMember(_ chatRoomId: Int64, _ chatMemberId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - banChatMember() called \(chatRoomId) \(chatMemberId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.banChatMember(chatRoomId: chatRoomId, chatMemberId: chatMemberId), completion: completion)
    }
    
    func getChatAdminMode(_ chatRoomId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - getChatAdminMode() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.getChatAdminMode(chatRoomId: chatRoomId), completion: completion)
    }
    
    /// 관리자 위임
    func delegateToAdmin(_ chatRoomId: Int64, _ chatMemberId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - delegateToAdmin() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.delegateToAdmin(chatRoomId: chatRoomId, chatMemberId: chatMemberId), completion: completion)
    }
    
    /// 채팅방장이 채팅방 삭제
    func deleteChatRoomByAdmin(_ chatRoomId: Int64, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatRoomAlamofire - deleteChatRoomByAdmin() called \(chatRoomId)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRoomRouter.deleteChatRoomByAdmin(chatRoomId: chatRoomId), completion: completion)
    }
}
