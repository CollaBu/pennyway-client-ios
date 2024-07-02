//
//
//import SwiftUI
//
//class DeleteSpendingHistoryViewModel: ObservableObject {
//    func deleteSpendingHistoryApi() {
//        SpendingAlamofire.shared.deleteSpendingHistory(spendingId: .spendingId.id!) { result in(targetAmountData?
//            switch result {
//            case let .success(data):
//                if let responseData = data {
//                    if let jsonString = String(data: responseData, encoding: .utf8) {
//                        Log.debug("지출내역 삭제: \(jsonString)")
//                    }
////                    self.isHiddenSuggestionView = true
////                    self.isPresentTargetAmount = false
//                }
//            case let .failure(error):
//                if let StatusSpecificError = error as? StatusSpecificError {
//                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
//                } else {
//                    Log.error("Network request failed: \(error)")
//                }
//            }
//        }
//    }
//
//}
//
