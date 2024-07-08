
import SwiftUI

struct CategorySpendingListView: View {
    var groupedSpendings: [(key: String, values: [IndividualSpending])]
    var onItemAppear: ((IndividualSpending) -> Void)?
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(groupedSpendings, id: \.key) { date, spendings in
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                
                Section(header: headerView(for: date)) {
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    ForEach(spendings, id: \.id) { item in
                        let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                        NavigationLink(destination: DetailSpendingView()) {
                            CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            .onAppear {
                                onItemAppear?(item)
                            }
                    }
                }
            }
            Spacer().frame(height: 18 * DynamicSizeFactor.factor())
        }
    }
    
    private func headerView(for date: String) -> some View {
        Text(dateFormatter(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func dateFormatter(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }
}
