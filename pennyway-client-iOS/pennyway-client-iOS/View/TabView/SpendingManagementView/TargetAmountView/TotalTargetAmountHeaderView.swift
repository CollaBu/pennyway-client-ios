
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
                
            Rectangle()
                .frame(width: 280 * DynamicSizeFactor.factor(), height: 38 * DynamicSizeFactor.factor())
                .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                .platformTextColor(color: Color("White01"))
        }
        .frame(maxWidth: .infinity)
        .background(Color("Mint03"))
    }
}
