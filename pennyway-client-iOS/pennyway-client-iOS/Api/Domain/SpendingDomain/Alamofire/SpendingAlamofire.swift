
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
        Log.info("SpendingAlamofire - getSpendingCustomCategoryList() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.getSpendingCustomCategoryList, completion: completion)
    }
    
    func addSpendingCustomCategory(_ dto: AddSpendingCustomCategoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - addSpendingCustomCategory() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.addSpendingCustomCategory(dto: dto), completion: completion)
    }
    
    func addSpendingHistory(_ dto: AddSpendingHistoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - addSpendingHistory() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.addSpendingHistory(dto: dto), completion: completion)
    }
    
    func deleteSpendingHistory(spendingId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - deleteSpendingHistory() called")
    
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.deleteSpendingHistory(spendingId: spendingId), completion: completion)
    }
    
    func getDetailSpendingHistory(spendingId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getDetailSpendingHistory() called")
    
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.getDetailSpendingHistory(spendingId: spendingId), completion: completion)
    }
    
    func editSpendingHistory(spendingId: Int, _ dto: AddSpendingHistoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - editSpendingHistory() called")
    
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingRouter.editSpendingHistory(spendingId: spendingId, dto: dto), completion: completion)
    }
}
