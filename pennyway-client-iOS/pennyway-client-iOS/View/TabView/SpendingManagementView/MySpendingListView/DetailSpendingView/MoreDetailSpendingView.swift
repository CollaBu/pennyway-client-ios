import SwiftUI

struct MoreDetailSpendingView: View {
    @Binding var clickDate: Date?
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                    HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                        let iconName = SpendingListViewCategoryIconList(rawValue: spendingDetail.category.icon)?.iconName ?? ""
                        Image(iconName)
                            .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor())
                            .scaledToFill()
                        
                        Text(spendingDetail.category.name)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1SemiboldeFont())
                    }
                }
                Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                    Text("\(spendingDetail.amount)원")
                        .padding(.vertical, 4)
                        .platformTextColor(color: Color("Gray07"))
                        .font(.H1BoldFont())
                }
                    
                Spacer()

                HStack {
                    Text("날짜")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                    
                    if let date = clickDate {
                        Text(Date.getFormattedDate(from: date))
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1MediumFont())
                    }
                }
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                HStack {
                    Text("소비처")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                    
                    if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                        Text(spendingDetail.accountName)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1MediumFont())
                    }
                }
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                HStack {
                    Text("메모")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                }
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                
                if let spendingDetail = spendingHistoryViewModel.filteredSpendings(for: clickDate).first {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .frame(width: 280 * DynamicSizeFactor.factor(), height: 72 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Gray01"))
                            .cornerRadius(4)
                        
                        Text(spendingDetail.memo)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1MediumFont())
                            .padding(12 * DynamicSizeFactor.factor())
                    }
                }
            }
        }
    }
}
