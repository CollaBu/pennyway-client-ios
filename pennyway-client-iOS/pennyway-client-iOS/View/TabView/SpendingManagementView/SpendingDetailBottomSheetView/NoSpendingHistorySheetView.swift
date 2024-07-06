
import SwiftUI

struct NoSpendingHistorySheetView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                    
                HStack(alignment: .center, spacing: 10) {
                    Text("최고의 소비")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Mint03"))
                }
                .padding(.horizontal, 10 * DynamicSizeFactor.factor())
                .padding(.vertical, 4 * DynamicSizeFactor.factor())
                .background(Color("Ashblue"))
                .cornerRadius(15)
                    
                Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                    
                Text("-0원")
                    .font(.H1BoldFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.vertical, 3 * DynamicSizeFactor.factor()) // line-height 적용하면 지울것
                    
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                    
                Text("절약했군요! 친구들에게 자랑해 볼까요?")
                    .font(.B1MediumFont())
                    .platformTextColor(color: Color("Gray04"))
            }
        }
    }
}

// #Preview {
//    NoSpendingHistoryView()
// }
