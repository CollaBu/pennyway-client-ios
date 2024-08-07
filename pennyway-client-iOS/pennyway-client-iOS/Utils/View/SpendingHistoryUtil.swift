
import Foundation

class SpendingHistoryUtil {
    static func getSpendingAmount(for day: Int, from viewModel: SpendingHistoryViewModel) -> Int? {
        return viewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    static func getSpendingAmount(for date: Date, using calendar: Calendar, from viewModel: SpendingHistoryViewModel) -> Int? {
        let day = calendar.component(.day, from: date)
        return getSpendingAmount(for: day, from: viewModel)
    }
}
