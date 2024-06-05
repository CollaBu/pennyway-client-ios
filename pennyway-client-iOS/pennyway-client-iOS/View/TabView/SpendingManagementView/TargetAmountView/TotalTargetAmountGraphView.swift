
import SwiftUI

struct TotalTargetAmountGraphView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    var body: some View {
        HStack(spacing: 24 * DynamicSizeFactor.factor()) {
            ForEach(viewModel.sortTargetAmounts.prefix(6)) { content in
                VStack {
                    Text("\(content.totalSpending / 10000)")
                        .font(.B3MediumFont())
                        .platformTextColor(color: determineColorGray04(for: content))
                    Rectangle()
                        .frame(width: 16 * DynamicSizeFactor.factor(), height: CGFloat(content.totalSpending / 10000) * DynamicSizeFactor.factor())
                        .platformTextColor(color: determineColorGray03(for: content))
                        .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                    Text("\(content.month)월")
                        .font(.B3MediumFont())
                        .platformTextColor(color: determineColorGray06(for: content))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140 * DynamicSizeFactor.factor(), alignment: .center) // TODO: height 수정 필요
    }

    func determineColorGray03(for content: TargetAmountData) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount < 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray03")
        }
    }

    func determineColorGray04(for content: TargetAmountData) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount < 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray04")
        }
    }

    func determineColorGray06(for content: TargetAmountData) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount < 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray06")
        }
    }
}
