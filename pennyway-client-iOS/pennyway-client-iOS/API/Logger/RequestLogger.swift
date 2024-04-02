
import Alamofire
import Foundation

final class RequestLogger: EventMonitor {
    let queue = DispatchQueue(label: "MyLogger")

    func requestDidResume(_ request: Request) {
        print("RequestLogger - requestDidResume")
        debugPrint(request)
    }

    func request(_ request: DataRequest, didParseResponse _: DataResponse<Data?, AFError>) {

        print("RequestLogger - request.didParseResponse()")
        debugPrint(request)
    }
}
