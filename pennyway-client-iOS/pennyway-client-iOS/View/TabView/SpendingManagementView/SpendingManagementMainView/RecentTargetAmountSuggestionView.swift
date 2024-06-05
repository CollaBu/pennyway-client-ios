import SwiftUI

struct RecentTargetAmountSuggestionView: View {
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
                }, label: {
                    Image("icon_close")
                        .resizable()
                        .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                })
            }
            .padding(.leading, 18)
            .padding(.trailing, 13)
    
            Text("6월 목표금액: 500,000원")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Mint02"))
                .padding(.leading, 18)
            
            Spacer()
            
            HStack {
                Image("icon_illust_error")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100 * DynamicSizeFactor.factor(), height: 75 * DynamicSizeFactor.factor())
                    .border(Color.black)
                
                Spacer()
                
                Button(action: {
                    isHidden = true
                    showToastPopup = true
                    
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
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 145 * DynamicSizeFactor.factor())
        .background(Color("Mint03"))
        .cornerRadius(8)
        .shadow(color: Color(red: 0, green: 0.83, blue: 0.88).opacity(0.15), radius: 5, x: 0, y: 1) // TODO: 색상 변경 필요
        .padding(.horizontal, 20)
    }
}
