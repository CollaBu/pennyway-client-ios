
import SwiftUI

struct SpendingCheckBoxView: View {
    @ObservedObject var viewModel: TargetAmountViewModel

    let baseAttribute = BaseAttribute(font: .H3SemiboldFont(), color: Color("Gray07"))

    var formattedTotalSpent: String {
        if let targetAmountData = viewModel.targetAmountData {
            return NumberFormatterUtil.formatIntToDecimalString(targetAmountData.totalSpending)
        } else {
            return "0"
        }
    }

    var spentInfoText: String {
        "반가워요 \(String(describing: getUserData()?.username ?? ""))님! \n이번 달에 \(formattedTotalSpent)원 썼어요"
    }

    var totalSpending: Int {
        viewModel.targetAmountData?.totalSpending ?? 0
    }

    var targetAmount: Int {
        viewModel.targetAmountData?.targetAmountDetail.amount ?? 0
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 18)

            HStack {
                spentInfoText.toAttributesText(base: baseAttribute,
                                               StringAttribute(
                                                   text: "\(formattedTotalSpent)원",
                                                   font: .H3SemiboldFont(),
                                                   color: targetAmount != -1 && totalSpending > targetAmount ? Color("Red03") : Color("Mint03")
                                               ))
                                               .lineSpacing(3)
                Spacer()
            }
            .frame(height: 44 * DynamicSizeFactor.factor())
            .padding(.leading, 18)

            Spacer().frame(height: 20)

            // 프로그래스 바
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 76, height: 24 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Gray01"))
                    .cornerRadius(15)

                let progressWidth: CGFloat = {
                    if targetAmount <= 0 {
                        return 0
                    }
                    let ratio = CGFloat(totalSpending) / CGFloat(targetAmount)
                    let width = ratio * (UIScreen.main.bounds.width - 76)
                    return min(max(width, 0), UIScreen.main.bounds.width - 76)
                }()

                Rectangle()
                    .frame(width: progressWidth, height: 24 * DynamicSizeFactor.factor()) // 현재 지출에 따른 프로그래스 바
                    .platformTextColor(color: totalSpending > targetAmount ? Color("Red03") : Color("Mint03"))
                    .cornerRadius(15)
            }

            Spacer().frame(height: 2)

            HStack {
                if viewModel.isPresentTargetAmount == true {
                    Text("\(totalSpending)")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: totalSpending > targetAmount ? Color("Red03") : Color("Mint03"))

                    Spacer()

                    NavigationLink(destination: TotalTargetAmountView()) {
                        HStack(spacing: 0) {
                            Text("\(targetAmount)")
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Gray07"))

                            Image("icon_arrow_front_small")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        }
                        .frame(width: 79 * DynamicSizeFactor.factor(), alignment: .trailing)
                    }
                } else {
                    Spacer()

                    NavigationLink(destination: TotalTargetAmountView()) {
                        HStack(spacing: 0) {
                            Text("목표금액 설정하기")
                                .font(.B1SemiboldeFont())
                                .platformTextColor(color: Color("Mint03"))

                            Image("icon_arrow_front_small")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        }
                        .frame(width: 110 * DynamicSizeFactor.factor(), alignment: .trailing)
                    }
                }
            }
            .padding(.leading, 22)
            .padding(.trailing, 13)

            Spacer().frame(height: 16)
        }
        .frame(maxWidth: .infinity, maxHeight: 144 * DynamicSizeFactor.factor())
        .background(Color("White01"))
        .cornerRadius(8)
    }
}
