
import SwiftUI

struct NoSpendingHistorySheetView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 13 * DynamicSizeFactor.factor())
                        
                    HStack(alignment: .center, spacing: 10) {
                        Text("절약왕")
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Mint03"))
                    }
                    .padding(.horizontal, 10 * DynamicSizeFactor.factor())
                    .padding(.vertical, 4 * DynamicSizeFactor.factor())
                    .background(Color("Ashblue01"))
                    .cornerRadius(15)
                        
                    Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                    
                    HStack {
                        Text("-0원")
                            .font(.H1BoldFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.vertical, 3 * DynamicSizeFactor.factor()) // line-height 적용하면 지울것
                        
                        Spacer()
                    }

                    Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                        
                    Text("\(getUserData()!.name)님은 절약왕이 될 상이에요!\n친구들에게 자랑해 볼까요?")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray05"))
                        .lineSpacing(5)
                }
            }
        }
        .padding(.leading, 20)
    }
}
