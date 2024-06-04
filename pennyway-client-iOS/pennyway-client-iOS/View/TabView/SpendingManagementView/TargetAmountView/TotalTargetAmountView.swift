import SwiftUI

struct TotalTargetAmountView: View {
    var body: some View {
        VStack(spacing: 0) {
            TotalTargetAmountHeaderView()

            VStack {
                HStack {
                    HStack {
                        Text("0원") // 이미지로 변경
                            .font(.headline)
                        
                        Text("남은 금액")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                    .padding(.leading, 14)
                    .padding(.bottom, 12)
                    
                    Spacer()
                    
                    Text("500,000원")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                }
                .frame(width: 280 * DynamicSizeFactor.factor(), height: 38 * DynamicSizeFactor.factor())
                .background(
                    RoundedCornerUtil(radius: 8, corners: [.bottomLeft, .bottomRight])
                        .fill(Color("White01"))
                )
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                
                // 여기
                TotalTargetAmountContentView()
                
                Spacer()
            }
        }
        .background(Color("Gray01"))
    }
}

#Preview {
    TotalTargetAmountView()
}
