
import Alamofire
import Foundation

class TargetAmountAlamofire {
    static let shared = TargetAmountAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getTargetAmountForDate(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getTargetAmountForDate() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.getTargetAmountForDate, completion: completion)
    }
    
    func getTotalTargetAmount(dto: GetTotalTargetAmountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getTotalTargetAmount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.getTotalTargetAmount(dto: dto), completion: completion)
    }
}
