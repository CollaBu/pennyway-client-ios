
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

    /// 채팅방 대기 요청
    func pendChatRoom(_ dto: PendChatRoomRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("ChatAlamofire - pendChatRoom() called \(dto)")

        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: ChatRouter.pendChatRoom(dto: dto), completion: completion)
    }
}
