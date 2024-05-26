

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    // 카테고리

    /// 카테고리 선택
    @Published var selectedCategory: (String, String)? = nil
    @Published var isCategoryListViewPresented: Bool = false

    /// 카테고리 생성
    @Published var selectedCategoryIcon: String? = nil
    @Published var categoryName: String = ""
    @Published var isAddCategoryFormValid = false
    @Published var navigateToAddCategory = false // 추가하기 버튼 누른 경우
    @Published var isSelectAddCategoryViewPresented: Bool = false

    /// 날짜 선택
    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()

    /// 가격, 소비처, 메모 text
    @Published var amountSpentText: String = ""
    @Published var consumerText: String = ""
    @Published var memoText: String = ""

    @Published var isFormValid = false // 지출내역 추가 valid

    func validateForm() {
        isFormValid = (selectedCategory != nil && !amountSpentText.isEmpty)
    }
}
