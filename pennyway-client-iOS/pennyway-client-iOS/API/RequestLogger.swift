
import Foundation
import Alamofire

final class RequestLogger : EventMonitor {
    let queue = DispatchQueue(label: "MyLogger")
    
    func requestDidResume(_ request: Request) {
        print("RequestLogger - requestDidResume")
        debugPrint(request)
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("RequestLogger - request.didParseResponse()")
        debugPrint(request)
    }
}
