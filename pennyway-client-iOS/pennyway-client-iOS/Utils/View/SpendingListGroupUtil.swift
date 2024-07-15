
import Foundation

enum SpendingListGroupUtil {
    static func groupedSpendings(from spendings: [IndividualSpending]) -> [(key: String, values: [IndividualSpending])] {
        let grouped = Dictionary(grouping: spendings, by: { String($0.spendAt.prefix(10)) })
        let sortedGroup = grouped.map { (key: $0.key, values: $0.value) }
            .sorted { group1, group2 -> Bool in
                if let date1 = DateFormatterUtil.dateFromString(group1.key + " 00:00:00"), let date2 = DateFormatterUtil.dateFromString(group2.key + " 00:00:00") {
                    return date1 > date2
                }
                return false
            }
        return sortedGroup
    }
}
