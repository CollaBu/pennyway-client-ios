
import SwiftUI

struct TotalTargetAmountGraphView: View {
    var body: some View {
        HStack(spacing: 24 * DynamicSizeFactor.factor()) {
            ForEach(1 ..< 7) { month in
                VStack {
                    Text("\(Int.random(in: 50 ... 90))")
                        .font(.B3MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                    Rectangle()
                        .frame(width: 16 * DynamicSizeFactor.factor(), height: CGFloat(Int.random(in: 99 ... 100)) * DynamicSizeFactor.factor())
                        .platformTextColor(color: Color("Gray03"))
                        .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                    Text("\(month)월")
                        .font(.B3MediumFont())
                        .platformTextColor(color: Color("Gray06"))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140 * DynamicSizeFactor.factor(), alignment: .center) // TODO: height 수정 필요
    }
}
