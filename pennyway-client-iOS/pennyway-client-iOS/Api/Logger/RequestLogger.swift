
import Alamofire
import Foundation

final class RequestLogger: EventMonitor {
    let queue = DispatchQueue(label: "MyLogger")

    func requestDidResume(_ request: Request) {
        Log.info("RequestLogger - requestDidResume")
        debugPrint(request)
    }

    func request(_ request: DataRequest, didParseResponse _: DataResponse<Data?, AFError>) {
        Log.info("RequestLogger - request.didParseResponse()")
        debugPrint(request)
    }
}
