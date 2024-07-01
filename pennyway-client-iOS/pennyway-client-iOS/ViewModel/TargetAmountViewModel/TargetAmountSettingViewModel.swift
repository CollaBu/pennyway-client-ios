
import SwiftUI

// MARK: - TargetAmountSettingViewModel

class TargetAmountSettingViewModel: ObservableObject {
    @Published var inputTargetAmount = ""
    @Published var isFormValid = false
    
    func validateForm() {
        isFormValid = !inputTargetAmount.isEmpty
    }
}
