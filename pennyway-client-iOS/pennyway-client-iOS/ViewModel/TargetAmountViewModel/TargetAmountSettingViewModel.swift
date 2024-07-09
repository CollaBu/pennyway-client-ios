
import SwiftUI

// MARK: - TargetAmountSettingViewModel

class TargetAmountSettingViewModel: ObservableObject {
    @Published var currentData: TargetAmount? = nil
    @Published var inputTargetAmount = ""
    @Published var isFormValid = false

    init(currentData: TargetAmount) {
        self.currentData = currentData
        inputTargetAmount = String(currentData.targetAmountDetail.amount)
    }

    func validateForm() {
        isFormValid = !inputTargetAmount.isEmpty
    }

    func editCurrentMonthTargetAmountApi() {
        let editCurrentMonthTargetAmountRequestDto = EditCurrentMonthTargetAmountRequestDto(amount: currentData?.targetAmountDetail.amount ?? 0)

        TargetAmountAlamofire.shared.editCurrentMonthTargetAmount(targetAmountId: currentData?.targetAmountDetail.id ?? -1, dto: editCurrentMonthTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    if let jsonString = String(data: responseData, encoding: .utf8) {
                        Log.debug("당월 목표 금액 수정 완료 \(jsonString)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}
