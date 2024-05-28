
import Alamofire
import Foundation

class SpendingAlamofire {
    static let shared = SpendingAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getSpendingHistory(_ dto: GetSpendingHistoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getSpendingHistory() called \(dto)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.getSpendingHistory(dto: dto), completion: completion)
    }
    
    func getSpendingCustomCategoryList(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getSpendingCustomCategoryList() called \(dto)")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.getSpendingCustomCategoryList, completion: completion)
    }
}
