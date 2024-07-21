
import Alamofire
import Foundation

class SpendingCategoryAlamofire {
    static let shared = SpendingCategoryAlamofire()
    
    let monitors = [RequestLogger(), ApiStatusLogger()] as [EventMonitor]

    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getSpendingCustomCategoryList(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingCategoryAlamofire - getSpendingCustomCategoryList() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingCategoryRouter.getSpendingCustomCategoryList, completion: completion)
    }
    
    func addSpendingCustomCategory(_ dto: AddSpendingCustomCategoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingCategoryAlamofire - addSpendingCustomCategory() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingCategoryRouter.addSpendingCustomCategory(dto: dto), completion: completion)
    }
    
    func getCategorySpendingCount(_ categoryId: Int, _ dto: GetCategorySpendingCountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingCategoryAlamofire - getCategorySpendingCount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingCategoryRouter.getCategorySpendingCount(categoryId: categoryId, dto: dto), completion: completion)
    }
    
    func getCategorySpendingHistory(_ categoryId: Int, _ dto: GetCategorySpendingHistoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingCategoryAlamofire - getCategorySpendingHistory() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingCategoryRouter.getCategorySpendingHistory(categoryId: categoryId, dto: dto), completion: completion)
    }

    func modifyCategory(_ categoryId: Int, _ dto: AddSpendingCustomCategoryRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingCategoryAlamofire - modifyCategory() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: SpendingCategoryRouter.modifyCategory(categoryId: categoryId, dto: dto), completion: completion)
    }
}
