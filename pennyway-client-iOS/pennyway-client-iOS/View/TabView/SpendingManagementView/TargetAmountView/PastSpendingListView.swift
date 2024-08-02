
import SwiftUI

struct PastSpendingListView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    
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
                                        text: determineText(for: content.diffAmount),
                                        backgroundColor: determineBackgroundColor(for: content.diffAmount),
                                        textColor: determineTextColor(for: content.diffAmount)
                                    )
                                }
                            }
                            
                            Spacer()
                            
                            Image("icon_arrow_front_small_gray03")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
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
    }
    
    /// Color 설정
    func determineBackgroundColor(for diffAmount: Int64) -> Color {
        return diffAmount > 0 ? Color("Red01") : Color("Ashblue01")
    }
    
    func determineTextColor(for diffAmount: Int64) -> Color {
        return diffAmount > 0 ? Color("Red03") : Color("Mint03")
    }

    func determineText(for diffAmount: Int64) -> String {
        let diffAmountValue = (NumberFormatterUtil.formatIntToDecimalString(abs(diffAmount)))
        
        if diffAmount != 0 {
            return diffAmount < 0 ? "\(diffAmountValue)원 절약했어요" : "\(diffAmountValue)원 더 썼어요"
        } else {
            return "짝짝 소비 천재네요!"
        }
    }
}
