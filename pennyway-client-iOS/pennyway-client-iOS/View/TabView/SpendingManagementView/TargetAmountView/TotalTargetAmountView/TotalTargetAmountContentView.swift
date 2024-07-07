import SwiftUI

struct TotalTargetAmountContentView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 4) {
                    Image("icon_remaining_amount")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    
                    Text("남은 금액")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.leading, 14)
                .padding(.bottom, 12)
                
                Spacer()
                
                Text(viewModel.currentData.targetAmountDetail.amount != -1 ? "\(viewModel.currentData.diffAmount)원" : "-원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: determineDiffAmountColor(for: viewModel.currentData.diffAmount))
                    .padding(.trailing, 16)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 38 * DynamicSizeFactor.factor())
            .background(
                RoundedCornerUtil(radius: 8, corners: [.bottomLeft, .bottomRight])
                    .fill(Color("White01"))
            )
            
            Spacer().frame(height: 13 * DynamicSizeFactor.factor())
            
            VStack {
                HStack {
                    Text("지난 사용 금액")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.leading, 18)
                    
                    Spacer()
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .padding(.trailing, 10)
                }
                .padding(.top, 18)
                
                Spacer().frame(height: 11 * DynamicSizeFactor.factor())
                
                TotalTargetAmountGraphView(viewModel: viewModel)
                
                Spacer().frame(height: 36 * DynamicSizeFactor.factor())
                
                ForEach(Array(viewModel.targetAmounts.enumerated()), id: \.offset) { _, content in
                    VStack(alignment: .leading) {
                        Text("\(String(content.year))년 \(content.month)월")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                        
                        Spacer().frame(height: 8)
                        
                        HStack {
                            Text("\(content.totalSpending)원")
                                .font(.ButtonH4SemiboldFont())
                                .platformTextColor(color: Color("Gray07"))
                            
                            Spacer()
                            
                            DiffAmountDynamicWidthView(
                                text: determineText(for: content.diffAmount),
                                backgroundColor: determineBackgroundColor(for: content.diffAmount),
                                textColor: determineTextColor(for: content.diffAmount)
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .frame(height: 60 * DynamicSizeFactor.factor())
                
                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            }
            .background(Color("White01"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
    
    // Color 설정
    
    func determineDiffAmountColor(for diffAmount: Int) -> Color {
        if viewModel.currentData.targetAmountDetail.amount != -1 {
            return diffAmount <= 0 ? Color("Red03") : Color("Gray07")
        } else {
            return Color("Gray07")
        }
    }
    
    func determineBackgroundColor(for diffAmount: Int) -> Color {
        return diffAmount < 0 ? Color("Red01") : Color("Ashblue01")
    }
    
    func determineTextColor(for diffAmount: Int) -> Color {
        return diffAmount < 0 ? Color("Red03") : Color("Mint03")
    }
    
    func determineText(for diffAmount: Int) -> String {
        let diffAmountValue = (NumberFormatterUtil.formatIntToDecimalString(abs(diffAmount)))
        
        if diffAmount != 0 {
            return diffAmount > 0 ? "\(diffAmountValue)원 절약했어요" : "\(diffAmountValue)원 더 썼어요"
        } else {
            return "짝짝 소비 천재네요!"
        }
    }
}