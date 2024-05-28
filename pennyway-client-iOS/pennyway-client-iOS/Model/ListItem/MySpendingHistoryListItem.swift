
import SwiftUI

// MARK: - MySpendingHistoryListItem

struct MySpendingHistoryListItem: Identifiable {
    var id = UUID()
    var category: String
    var amount: Int
    var date: Date
}

let expenses = [
    MySpendingHistoryListItem(category: "식비", amount: 32000, date: Date()),
    MySpendingHistoryListItem(category: "교통", amount: 7500, date: Date()),
]
