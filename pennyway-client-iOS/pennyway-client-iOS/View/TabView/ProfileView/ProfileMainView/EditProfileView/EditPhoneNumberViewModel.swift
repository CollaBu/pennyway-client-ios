
import SwiftUI

class EditPhoneNumberViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var code = ""
    @Published var isDisabledButton = true
}
