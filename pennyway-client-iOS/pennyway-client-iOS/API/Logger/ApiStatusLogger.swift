
import Alamofire
import Foundation

final class ApiStatusLogger: EventMonitor {
    let queue = DispatchQueue(label: "ApiStatusLogger")

    func request(_ request: DataRequest, didParseResponse _: DataResponse<Data?, AFError>) {
        guard let statusCode = request.response?.statusCode else {
            return
        }

        print("ApiStatusLogger - statusCode : \(statusCode)")
        debugPrint(request)
    }
}
