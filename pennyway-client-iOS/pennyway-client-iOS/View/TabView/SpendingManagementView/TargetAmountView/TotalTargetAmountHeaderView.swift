
import SwiftUI

struct TotalTargetAmountHeaderView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
            VStack(alignment: .leading, spacing: 8) {
                Text("2024년 6월 목표금액")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("White01"))
                    
                HStack(spacing: 0) {
                    Text("500,000")
                        .font(.H1BoldFont())
                        .platformTextColor(color: Color("White01"))
                    Text("원")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("White01"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 135 * DynamicSizeFactor.factor())
            .padding(.horizontal, 20)
                
            HStack {
                HStack(spacing: 0) {
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    
                    Text("현재 소비 금액")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.leading, 14)
                .padding(.top, 12)
                
                Spacer()
                
                Text("0원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.trailing, 16)
                    .padding(.top, 12)
            }
            .frame(width: 280 * DynamicSizeFactor.factor(), height: 38 * DynamicSizeFactor.factor())
            .background(
                RoundedCornerUtil(radius: 8, corners: [.topLeft, .topRight])
                    .fill(Color("White01"))
            )
        }
        .frame(maxWidth: .infinity)
        .background(Color("Mint03"))
    }
}
