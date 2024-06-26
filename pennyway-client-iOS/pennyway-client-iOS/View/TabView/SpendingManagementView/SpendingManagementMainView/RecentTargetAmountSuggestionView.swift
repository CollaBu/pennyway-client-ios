import SwiftUI

struct RecentTargetAmountSuggestionView: View {
    @ObservedObject var viewModel: TargetAmountViewModel
    @Binding var showToastPopup: Bool
    @Binding var isHidden: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 18 * DynamicSizeFactor.factor())

            HStack {
                Text("최근 목표금액을 그대로 사용할까요?")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("White01"))
                
                Spacer()
                
                Button(action: {
                    isHidden = true
                    viewModel.deleteCurrentMonthTargetAmountApi()
                }, label: {
                    Image("icon_close_white")
                        .resizable()
                        .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                })
            }
            .padding(.leading, 18 * DynamicSizeFactor.factor())
            .padding(.trailing, 13 * DynamicSizeFactor.factor())
    
            Text("\(viewModel.recentTargetAmountData?.month ?? 0)월 목표금액: \(NumberFormatterUtil.formatIntToDecimalString(viewModel.recentTargetAmountData?.amount ?? 0))원")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Mint02"))
                .padding(.leading, 18 * DynamicSizeFactor.factor())
            
            Spacer()
            
            HStack {
                Image("icon_illust_maintain goal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85 * DynamicSizeFactor.factor(), height: 85 * DynamicSizeFactor.factor())
                
                Spacer()
                
                Button(action: {
                    isHidden = true
                    showToastPopup = true
                    viewModel.editCurrentMonthTargetAmountApi()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToastPopup = false
                    }
                    
                }, label: {
                    Text("사용하기")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Mint03"))
                        .frame(width: 63 * DynamicSizeFactor.factor(), height: 30 * DynamicSizeFactor.factor())
                        .background(Color("White01"))
                        .cornerRadius(30)
                }).frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 18 * DynamicSizeFactor.factor())
            }
            .padding(.leading, 28 * DynamicSizeFactor.factor())
            .padding(.trailing, 19 * DynamicSizeFactor.factor())
        }
        .frame(height: 145 * DynamicSizeFactor.factor())
        .background(Color("Mint03"))
        .cornerRadius(8)
        .shadow(color: Color(red: 0, green: 0.83, blue: 0.88).opacity(0.15), radius: 5, x: 0, y: 1) // TODO: 색상 변경 필요
        .padding(.horizontal, 20)
    }
}
