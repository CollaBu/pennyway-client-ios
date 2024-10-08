import SwiftUI

struct TotalTargetAmountContentView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    @Binding var isnavigateToPastSpendingView: Bool

    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        VStack {
            Spacer().frame(height: 13 * DynamicSizeFactor.factor())

            VStack {
                HStack {
                    Text("지난 사용 금액")
                        .font(.B1SemiboldeFont())
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

                Spacer().frame(height: 11 * DynamicSizeFactor.factor())

                TotalTargetAmountGraphView(viewModel: viewModel)

                Spacer().frame(height: 36 * DynamicSizeFactor.factor())

                ForEach(Array(viewModel.targetAmounts.prefix(6).enumerated()), id: \.offset) { _, content in
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
