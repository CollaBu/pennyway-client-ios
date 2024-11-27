import SwiftUI

struct TotalTargetAmountContentView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    @Binding var isnavigateToPastSpendingView: Bool

    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        VStack {
            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            VStack(alignment: .leading) {
                HStack {
                    Text("지난 사용 금액")
                        .font(.ButtonH4SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.leading, 18)

                    Spacer()

                    Button(action: {
                        isnavigateToPastSpendingView = true
                    }, label: {
                        Image("icon_arrow_front_small")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(.trailing, 10)
                    })
                    .buttonStyle(BasicButtonStyleUtil())
                }
                .padding(.top, 18)

                Spacer().frame(height: 13 * DynamicSizeFactor.factor())

                HStack(spacing: 12 * DynamicSizeFactor.factor()) {
                    HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                        Circle()
                            .frame(width: 6 * DynamicSizeFactor.factor(), height: 6 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Mint01"))

                        Text("목표금액")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.B3MediumFont())
                    }

                    HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                        Circle()
                            .frame(width: 6 * DynamicSizeFactor.factor(), height: 6 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("mint02"))

                        Text("소비금액")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.B3MediumFont())
                    }

                    HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                        Circle()
                            .frame(width: 6 * DynamicSizeFactor.factor(), height: 6 * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Mint03"))

                        Text("초과금액")
                            .platformTextColor(color: Color("Gray04"))
                            .font(.B3MediumFont())
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 11 * DynamicSizeFactor.factor())

                TotalTargetAmountGraphView(viewModel: viewModel)

                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: 244 * DynamicSizeFactor.factor(), maxHeight: 0.5)
                    .background(Color("Gray02"))
                    .padding(.horizontal, 18 * DynamicSizeFactor.factor())

                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                Text("최근 3개월 동안 사용한 금액이에요")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.horizontal, 20)

                Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                ForEach(Array(viewModel.targetAmounts
                        .filter { $0.month < Date.month(from: Date()) || $0.year < Date.year(from: Date()) } // 현재 달 제외
                        .prefix(3).enumerated()), id: \.offset)
                { _, content in
                    VStack(alignment: .leading) {
                        Text("\(String(content.year))년 \(content.month)월")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))

                        Spacer().frame(height: 8)

                        HStack {
                            Text("\(content.totalSpending)원")
                                .font(.ButtonH4SemiboldFont())
                                .platformTextColor(color: Color("Gray07"))

                            Spacer()

                            if content.targetAmountDetail.amount != -1 {
                                DiffAmountDynamicWidthView(
                                    text: DiffAmountColorUtil.determineText(for: content.diffAmount),
                                    backgroundColor: DiffAmountColorUtil.determineBackgroundColor(for: content.diffAmount),
                                    textColor: DiffAmountColorUtil.determineTextColor(for: content.diffAmount)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .frame(height: 60 * DynamicSizeFactor.factor())

                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            }
            .background(Color("White01"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .background(Color("Gray01"))

        Spacer()
    }
}
