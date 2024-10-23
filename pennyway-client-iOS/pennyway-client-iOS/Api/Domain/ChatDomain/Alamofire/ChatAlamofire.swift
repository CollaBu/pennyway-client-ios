//
//  ChatAlamofire.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 10/22/24.
//

import Alamofire
import Foundation

class ChatAlamofire {
    static let shared = ChatAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    /// 채팅방 생성
    func makeChatRoom(_ dto: MakeChatRoomRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - makeChatRoom() called \(dto)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.makeChatRoom(dto: dto), completion: completion)
    }
    
    func getChatServer(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - getChatServer() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.getChatServer, completion: completion)
    }
}
