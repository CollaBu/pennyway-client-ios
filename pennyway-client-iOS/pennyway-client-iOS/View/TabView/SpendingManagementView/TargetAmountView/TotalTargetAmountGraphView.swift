
import SwiftUI

struct TotalTargetAmountGraphView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    var body: some View {
        HStack(spacing: 24 * DynamicSizeFactor.factor()) {
            ForEach(viewModel.sortTargetAmounts) { content in
                VStack {
                    Text("\(content.totalSpending / 10000)")
                        .font(.B3MediumFont())
                        .platformTextColor(color: content.month == 8 ? (content.diffAmount < 0 ? Color("Red03") : Color("Mint03")) : Color("Gray04"))
                    Rectangle()
                        .frame(width: 16 * DynamicSizeFactor.factor(), height: CGFloat(content.totalSpending / 10000) * DynamicSizeFactor.factor())
                        .platformTextColor(color: content.month == 8 ? (content.diffAmount < 0 ? Color("Red03") : Color("Mint03")) : Color("Gray03"))
                        .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                    Text("\(content.month)월")
                        .font(.B3MediumFont())
                        .platformTextColor(color: content.month == 8 ? (content.diffAmount < 0 ? Color("Red03") : Color("Mint03")) : Color("Gray06"))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140 * DynamicSizeFactor.factor(), alignment: .center) // TODO: height 수정 필요
    }
}
