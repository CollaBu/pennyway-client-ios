

import SwiftUI

class EditIdViewModel: ObservableObject {
    @Published var inputId = ""
    @Published var showErrorId = false
    @Published var isDuplicateId = false
    @Published var isFormValid = false

    func validateId() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorId = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: inputId)
        checkDuplicate()
        validateForm()
    }

    func checkDuplicate() {
        if inputId == "heejin" {
            isDuplicateId = true
        } else {
            isDuplicateId = false
        }
    }

    func validateForm() {
        if !isDuplicateId && !showErrorId && !inputId.isEmpty {
            isFormValid = true
        } else {
            isFormValid = false
        }
    }
}
