import SwiftUI

class InquiryViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var content: String = ""

    func validateEmail() {}
}
