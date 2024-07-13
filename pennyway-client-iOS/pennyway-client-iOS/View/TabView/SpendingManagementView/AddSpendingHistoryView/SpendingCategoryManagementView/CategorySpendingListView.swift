
import SwiftUI

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(groupedSpendings(from: viewModel.dailyDetailSpendings), id: \.key) { date, spendings in
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                
                Section(header: headerView(for: date)) {
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    ForEach(spendings, id: \.id) { item in
                        let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                        NavigationLink(destination: DetailSpendingView()) {
                            CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            guard let index = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == item.id }) else {
                                return
                            }
                            // 해당 index가 마지막 index라면 데이터 추가
                            if index == viewModel.dailyDetailSpendings.count - 1 {
                                Log.debug("지출 내역 index: \(index)")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
                                    viewModel.getCategorySpendingHistoryApi { _ in }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    }
                }
            }
            Spacer().frame(height: 18 * DynamicSizeFactor.factor())
        }
    }
    
    private func headerView(for date: String) -> some View {
        Text(DateFormatterUtil.dateFormatString(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func groupedSpendings(from spendings: [IndividualSpending]) -> [(key: String, values: [IndividualSpending])] {
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
