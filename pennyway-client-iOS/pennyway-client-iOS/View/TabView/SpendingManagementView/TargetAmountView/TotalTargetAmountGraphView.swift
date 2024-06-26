
import SwiftUI

struct TotalTargetAmountGraphView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    var body: some View {
        HStack(spacing: 24 * DynamicSizeFactor.factor()) {
            ForEach(0 ..< 6) { index in
                if index >= 6 - viewModel.sortTargetAmounts.count {
                    let content = viewModel.sortTargetAmounts[index - (6 - viewModel.sortTargetAmounts.count)]
                    VStack {
                        Text("\(content.totalSpending / 10000)")
                            .font(.B3MediumFont())
                            .platformTextColor(color: determineColorGray04(for: content))
                        Rectangle()
                            .frame(maxWidth: 16 * DynamicSizeFactor.factor(), maxHeight: CGFloat(content.totalSpending / 10000) * DynamicSizeFactor.factor())
                            .platformTextColor(color: determineColorGray03(for: content))
                            .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                        Text("\(content.month)월")
                            .font(.B3MediumFont())
                            .platformTextColor(color: determineColorGray06(for: content))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                } else {
                    VStack {
                        Text("0")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray03"))
                        Rectangle()
                            .frame(maxWidth: 16 * DynamicSizeFactor.factor(), maxHeight: 0)
                            .foregroundColor(.clear)
                        Text("\(viewModel.currentData.month - (6 - (index + 1)))월")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray03")) 
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140 * DynamicSizeFactor.factor(), alignment: .center)
    }

    func determineColorGray03(for content: TargetAmount) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount <= 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray03")
        }
    }

    func determineColorGray04(for content: TargetAmount) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount <= 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray04")
        }
    }

    func determineColorGray06(for content: TargetAmount) -> Color {
        if content.month == Date.month(from: Date()) {
            return content.diffAmount <= 0 ? Color("Red03") : Color("Mint03")
        } else {
            return Color("Gray06")
        }
    }
}
