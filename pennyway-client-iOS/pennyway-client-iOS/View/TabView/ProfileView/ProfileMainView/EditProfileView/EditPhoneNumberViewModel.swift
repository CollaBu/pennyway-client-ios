
import SwiftUI

class EditPhoneNumberViewModel: ObservableObject {
    private var timer: Timer?
    
    @Published var phoneNumber = ""
    @Published var code = ""
}
