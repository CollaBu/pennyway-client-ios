import Alamofire
import Foundation
import os.log

class BackofficeAlamofire: TokenHandler {
    static let shared = BackofficeAlamofire()

    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    var session: Session

    private init() {
        session = Session(eventMonitors: monitors)
    }

    func sendInquiryMail(_ dto: BackofficeRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("InquiryAlamofire - sendInquiryMail() called userInput \(dto)")

        ApiRequstHandler.shared.requestWithTokenHandling(session: session, router: BackofficeRouter.sendInquiryMail(dto: dto), completion: completion)
    }
}
