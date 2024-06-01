
import SwiftUI

struct SpendingCheckBoxView: View {
    @ObservedObject var viewModel: TargetAmountViewModel

    /// 프로그래스 바에 사용될 최대 값
    let baseAttribute = BaseAttribute(font: .H3SemiboldFont(), color: Color("Gray07"))

    var formattedTotalSpent: String {
        NumberFormatterUtil.formatNumber(viewModel.totalSpent)
    }

    var spentInfoText: String {
        "반가워요 \(String(describing: getUserData()?.username ?? ""))님! \n이번 달에 총 \(formattedTotalSpent)원 썼어요"
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 18)

            HStack {
                spentInfoText.toAttributesText(base: baseAttribute,
                                               StringAttribute(
                                                   text: "\(formattedTotalSpent)원",
                                                   font: .H3SemiboldFont(),
                                                   color: CGFloat(viewModel.totalSpent) > viewModel.targetValue ? Color("Red03") : Color("Mint03")
                                               ))
                Spacer()
            }
            .frame(height: 44 * DynamicSizeFactor.factor())
            .padding(.leading, 18)

            Spacer().frame(height: 20)

            // 프로그래스 바
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 76, height: 24 * DynamicSizeFactor.factor())
                    .foregroundColor(Color("Gray01"))
                    .cornerRadius(15)

                let progressWidth: CGFloat = {
                    if viewModel.targetValue <= 0 {
                        return 0
                    }
                    let ratio = CGFloat(viewModel.totalSpent) / viewModel.targetValue
                    let width = ratio * (UIScreen.main.bounds.width - 76)
                    return min(max(width, 0), UIScreen.main.bounds.width - 76)
                }()

                Rectangle()
                    .frame(width: progressWidth, height: 24 * DynamicSizeFactor.factor()) // 현재 지출에 따른 프로그래스 바
                    .platformTextColor(color: CGFloat(viewModel.totalSpent) > viewModel.targetValue ? Color("Red03") : Color("Mint03"))
                    .cornerRadius(15)
            }

            Spacer().frame(height: 2)

            HStack {
                Text("\(viewModel.totalSpent)")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: CGFloat(viewModel.totalSpent) > viewModel.targetValue ? Color("Red03") : Color("Mint03"))
                Spacer()

                HStack(spacing: 0) {
                    Text("\(Int(viewModel.targetValue))")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))

                    Button(action: {}, label: {
                        Image("icon_arrow_front_small")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    })
                }
                .frame(width: 79 * DynamicSizeFactor.factor(), alignment: .trailing)
                .onTapGesture {
                    Log.debug("목표 금액 클릭")
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
