

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    @Published var amountSpentText: String = ""
    @Published var isCategoryListViewPresented: Bool = false
    @Published var selectedCategory: (String, String)? = nil

    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()

    @Published var consumerText: String = ""

    @Published var memoText: String = ""

    @Published var isFormValid = false

    func validateForm() {
        isFormValid = (selectedCategory != nil && !amountSpentText.isEmpty)
    }
}
