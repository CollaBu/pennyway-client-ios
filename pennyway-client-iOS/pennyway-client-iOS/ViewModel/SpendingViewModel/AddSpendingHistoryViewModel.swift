

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    @Published var amountSpentText: String = ""
    @Published var isCategoryListViewPresented: Bool = false
    @Published var selectedCategoryIcon: String? = nil
    @Published var categoryName: String = ""

    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()

    @Published var consumerText: String = ""

    @Published var memoText: String = ""

    @Published var isFormValid = false

    @Published var isAddCategoryFormValid = false
    @Published var navigateToAddCategory = false
    @Published var isSelectAddCategoryViewPresented: Bool = false

    func validateForm() {
        isFormValid = (selectedCategoryIcon != nil && !categoryName.isEmpty && !amountSpentText.isEmpty)
    }

    func validateAddCategoryForm() {
        isAddCategoryFormValid = !categoryName.isEmpty
    }
}
