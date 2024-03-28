import SwiftUI

class LoginFormViewModel: ObservableObject {
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false

    
}

