
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
    
    func getTotalTargetAmount(_ dto: GetTotalTargetAmountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getTotalTargetAmount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.getTotalTargetAmount(dto: dto), completion: completion)
    }
    
    func generateCurrentMonthDummyData(_ dto: GenerateCurrentMonthDummyDataRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - generateCurrentMonthDummyData() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.generateCurrentMonthDummyData(dto: dto), completion: completion)
    }

    func deleteCurrentMonthTargetAmount(targetAmountId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - deleteCurrentMonthTargetAmount() called")
    
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.deleteCurrentMonthTargetAmount(targetAmountId: targetAmountId), completion: completion)
    }
    
    func editCurrentMonthTargetAmount(targetAmountId: Int, dto: EditCurrentMonthTargetAmountRequestDto, completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - editCurrentMonthTargetAmount() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.editCurrentMonthTargetAmount(targetAmountId: targetAmountId, dto: dto), completion: completion)
    }
    
    func getTargetAmountForPreviousMonth(completion: @escaping (Result<Data?, Error>) -> Void) {
        Log.info("SpendingAlamofire - getTargetAmountForPreviousMonth() called")
        
        ApiRequstHandler.shared.requestWithErrorHandling(session: session, router: TargetAmountRouter.getTargetAmountForPreviousMonth, completion: completion)
    }
}
