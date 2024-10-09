
import SwiftUI

struct TotalTargetAmountHeaderView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            Group {
                VStack(alignment: .leading, spacing: 8 * DynamicSizeFactor.factor()) {
                    Text("\(String(viewModel.currentData.year))년 \(viewModel.currentData.month)월 목표금액")
                        .font(.ButtonH4SemiboldFont())
                        .platformTextColor(color: Color("White01"))

                    HStack(spacing: 0) {
                        Text(viewModel.currentData.targetAmountDetail.amount != -1 ? "\(viewModel.currentData.targetAmountDetail.amount)" : "-")
                            .font(.H1BoldFont())
                            .platformTextColor(color: Color("White01"))
                        Text(" 원")
                            .font(.H3SemiboldFont())
                            .platformTextColor(color: Color("White01"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                HStack {
                    HStack(spacing: 4) {
                        Image("icon_ current_spending")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                        Text("현재 소비 금액")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                    .padding(.leading, 14)
                    .padding(.top, 12)

                    Spacer()

                    Text("\(viewModel.currentData.totalSpending)원")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.trailing, 16)
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 38 * DynamicSizeFactor.factor())
                .background(
                    RoundedCornerUtil(radius: 8, corners: [.topLeft, .topRight])
                        .fill(Color("White01"))
                )
                .padding(.horizontal, 20)
            }.background(Color("Mint03"))

            HStack {
                HStack {
                    HStack(spacing: 4) {
                        Image("icon_remaining_amount")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())

                        Text("남은 금액")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                    }
                    .padding(.leading, 14)
                    .padding(.bottom, 12)

                    Spacer()

                    Text(viewModel.currentData.targetAmountDetail.amount != -1 ? "\(viewModel.currentData.diffAmount <= 0 ? "" : "-")\(abs(viewModel.currentData.diffAmount))원" : "-원")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: determineDiffAmountColor(for: viewModel.currentData.diffAmount))
                        .padding(.trailing, 16)
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 38 * DynamicSizeFactor.factor())
                .background(
                    RoundedCornerUtil(radius: 8, corners: [.bottomLeft, .bottomRight])
                        .fill(Color("White01"))
                )
                .padding(.horizontal, 20)
            }.background(Color("Gray01"))
        }
        .frame(maxWidth: .infinity)
    }

    // Color 설정

    func determineDiffAmountColor(for diffAmount: Int64) -> Color {
        if viewModel.currentData.targetAmountDetail.amount != -1 {
            return diffAmount > 0 ? Color("Red03") : Color("Gray07")
        } else {
            return Color("Gray07")
        }
    }
}
