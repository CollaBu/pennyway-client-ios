
import SwiftUI

struct PastSpendingListView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    @State private var navigateToMySpendingList = false
    @State private var selectDate: Date = Date()
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                ForEach(Array(viewModel.targetAmounts.enumerated()), id: \.offset) { _, content in
                    VStack(alignment: .leading) {
                        Text("\(String(content.year))년 \(content.month)월")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                        
                        Spacer().frame(height: 8)
                        HStack {
                            HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                                Text("\(content.totalSpending)원")
                                    .font(.ButtonH4SemiboldFont())
                                    .platformTextColor(color: Color("Gray07"))
                                
                                if content.targetAmountDetail.amount != -1 {
                                    DiffAmountDynamicWidthView(
                                        text: DiffAmountColorUtil.determineText(for: content.diffAmount),
                                        backgroundColor: DiffAmountColorUtil.determineBackgroundColor(for: content.diffAmount),
                                        textColor: DiffAmountColorUtil.determineTextColor(for: content.diffAmount)
                                    )
                                }
                            }
                            
                            Spacer()
                            
                            Image("icon_arrow_front_small_gray03")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let components = DateComponents(year: content.year, month: content.month)
                            if let date = Calendar.current.date(from: components) {
                                selectDate = date
                            }
                            navigateToMySpendingList = true
                        }
                    }
                }
                .frame(height: 60 * DynamicSizeFactor.factor())
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "지난 사용 금액")
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        
        NavigationLink(destination: MySpendingListView(spendingHistoryViewModel: SpendingHistoryViewModel(), currentMonth: $selectDate, clickDate: .constant(nil)), isActive: $navigateToMySpendingList) {
            EmptyView()
        }
        .hidden()
    }
}
