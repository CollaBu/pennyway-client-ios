
import Alamofire
import Foundation
import os.log

class InquiryAlamofire: TokenHandler {
    static let shared = InquiryAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    var session: Session

    private init() {
        session = Session(eventMonitors: monitors)
    }

    func sendInquiryMail(_ dto: InquiryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("InquiryAlamofire - sendInquiryMail() called userInput : %@ ,, %@ ,, %@  ", log: .default, type: .info, dto.email, dto.content, dto.category)
        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: InquiryRouter.sendInquiryMail(dto: dto), completion: completion)
    }
}
