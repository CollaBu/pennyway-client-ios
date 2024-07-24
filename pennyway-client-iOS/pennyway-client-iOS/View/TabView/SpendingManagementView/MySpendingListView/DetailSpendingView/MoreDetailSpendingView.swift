import SwiftUI

struct MoreDetailSpendingView: View {
    @State var showingPopUp = false
    @Binding var clickDate: Date?
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    
    var spendingId: Int

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if let spendingDetail = getSpendingDetail(by: spendingId) {
                    HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                        let iconName = SpendingListViewCategoryIconList(rawValue: spendingDetail.category.icon)?.iconName ?? ""
                        
                        Image(iconName)
                            .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor())
                            .scaledToFill()
                        
                        Text(spendingDetail.category.name)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1SemiboldeFont())
                    }
                    
                    Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                    
                    Text("\(spendingDetail.amount)원")
                        .padding(.vertical, 4)
                        .platformTextColor(color: Color("Gray07"))
                        .font(.H1BoldFont())

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
                        } else {
                            // 지출 카테고리에서 진입한 경우
                            let date = DateFormatterUtil.dateFromString(spendingDetail.spendAt)
                            Text(Date.getFormattedDate(from: date ?? Date()))
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

                        Text(spendingDetail.accountName)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1MediumFont())
                    }
                    Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                    
                    HStack {
                        Text("메모")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.B1MediumFont())
                        
                        Spacer()
                    }
                    Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .frame(height: 72 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Gray01"))
                            .cornerRadius(4)
                            .padding(.bottom, 34 * DynamicSizeFactor.factor())

                        Text(spendingDetail.memo)
                            .platformTextColor(color: Color("Gray07"))
                            .font(.B1MediumFont())
                            .padding(12 * DynamicSizeFactor.factor())
                    }
                }
            }
        }
        .border(.black)
        .padding(.horizontal, 20)
        .onAppear {
            Log.debug("MoreDetailSpendingView :\(spendingCategoryViewModel.dailyDetailSpendings), \(spendingCategoryViewModel.amount), \(clickDate)")
        }
    }
    
    private func getSpendingDetail(by id: Int) -> IndividualSpending? {
        return spendingHistoryViewModel.getSpendingDetail(by: id) ?? spendingCategoryViewModel.getSpendingDetail(by: id)
    }
}
