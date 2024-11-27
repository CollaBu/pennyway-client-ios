
import SwiftUI

struct TotalTargetAmountGraphView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    var body: some View {
        let maxHeight = 120 * DynamicSizeFactor.factor() // 최대 높이
        let maxSpending = max(viewModel.maxTotalSpending, 100_000) // 최소값을 100000으로 설정

        HStack(spacing: 14 * DynamicSizeFactor.factor()) {
            ForEach(0 ..< 6) { index in
                if index >= 6 - viewModel.sortTargetAmounts.count {
                    let content = viewModel.sortTargetAmounts[index - (6 - viewModel.sortTargetAmounts.count)]
//                    let adjustedHeight = (maxSpending > 0) ? CGFloat(content.totalSpending) / CGFloat(maxSpending) * maxHeight : 0 // 그래프 높이 조정
                    // 그래프 높이 계산
                    let totalHeight = (CGFloat(content.totalSpending) / CGFloat(maxSpending)) * maxHeight
                    let overHeight = (content.diffAmount > 0) ? (CGFloat(content.diffAmount) / CGFloat(maxSpending)) * maxHeight : 0
                    let targetHeight = (content.targetAmountDetail.amount > 0) ? (CGFloat(content.targetAmountDetail.amount) / CGFloat(maxSpending)) * maxHeight : 0
                    let spendingHeight = totalHeight - overHeight

                    VStack {
                        Text("\(content.totalSpending / 10000)")
                            .font(.B3MediumFont())
                            .platformTextColor(color: determineColorGray04(for: content))

                        ZStack {
                            // 목표 금액
                            if targetHeight > 0 {
                                Rectangle()
                                    .platformTextColor(color: Color("Mint01"))
                                    .frame(width: 26 * DynamicSizeFactor.factor(), height: targetHeight)
                            }

                            // 사용 금액
                            Rectangle()
                                .platformTextColor(color: Color("mint02"))
                                .frame(width: 26 * DynamicSizeFactor.factor(), height: spendingHeight)

                            // 초과 금액
                            if overHeight > 0 {
                                Rectangle()
                                    .platformTextColor(color: Color("Mint03"))
                                    .frame(width: 26 * DynamicSizeFactor.factor(), height: overHeight)
                            }
                        }
//                        Rectangle()
//                            .frame(width: 26 * DynamicSizeFactor.factor(), height: adjustedHeight)
//                            .platformTextColor(color: determineColorGray03(for: content))
                        .clipShape(RoundedCornerUtil(radius: 4, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight]))

                        if content.totalSpending != 0 {
                            Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                        }

                        Text("\(content.month)월")
                            .font(.B3MediumFont())
                            .platformTextColor(color: determineColorGray06(for: content))
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                } else {
                    VStack {
                        Text("0")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                        Rectangle()
                            .frame(maxWidth: 26 * DynamicSizeFactor.factor(), maxHeight: 0)
                        Text("\(viewModel.currentData.month - (6 - (index + 1)))월")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray06"))
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
            if content.targetAmountDetail.amount != -1 {
                return content.diffAmount > 0 ? Color("Red03") : Color("Mint03")
            }
            return Color("Mint03")
        } else {
            return Color("Gray03")
        }
    }

    func determineColorGray04(for content: TargetAmount) -> Color {
        if content.month == Date.month(from: Date()) {
            if content.targetAmountDetail.amount != -1 {
                return content.diffAmount > 0 ? Color("Red03") : Color("Mint03")
            }
            return Color("Mint03")
        } else {
            return Color("Gray04")
        }
    }

    func determineColorGray06(for content: TargetAmount) -> Color {
        if content.month == Date.month(from: Date()) {
            if content.targetAmountDetail.amount != -1 {
                return content.diffAmount > 0 ? Color("Red03") : Color("Mint03")
            }
            return Color("Mint03")
        } else {
            return Color("Gray06")
        }
    }
}
