
import Foundation

class SignUpNavigationViewModel: ObservableObject {
    @Published var selectedText: Int? = 1 // 초기 값은 1으로 설정

    func continueButtonTapped() {
        if let selectedText = selectedText {
            self.selectedText = selectedText + 1
        }
    }
}
