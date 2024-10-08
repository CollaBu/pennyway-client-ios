
import SwiftUI

struct PastSpendingListView: View {
    @ObservedObject var viewModel: TotalTargetAmountViewModel
    @State private var navigateToMySpendingList = false
    @State var currentMonth: Date = .init()
    @State var clickDate: Date?

    var body: some View {
        ZStack {
            if viewModel.targetAmounts.isEmpty {
                emptyStateView()
            } else {
                contentListView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White01"))
        .navigationBarColor(UIColor(named: "White01"), title: "지난 사용 금액")
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
        }
        .analyzeEvent(TargetAmountEvents.targetAmountHistoryView)

        NavigationLink(destination: MySpendingListView(spendingHistoryViewModel: SpendingHistoryViewModel(), currentMonth: $currentMonth, clickDate: $clickDate), isActive: $navigateToMySpendingList) {
            EmptyView()
        }
        .hidden()
    }

    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack {
            Spacer()

            VStack {
                Image("icon_illust_nohistory")
                    .frame(width: 50 * DynamicSizeFactor.factor(), height: 66 * DynamicSizeFactor.factor())
                    .padding()

                Text("아직 기록이 없어요")
                    .platformTextColor(color: Color("Gray04"))
                    .font(.H4MediumFont())
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func contentListView() -> some View {
        ScrollView {
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())

            ForEach(Array(viewModel.targetAmounts.enumerated()), id: \.offset) { _, content in
                VStack(alignment: .leading) {
                    Text("\(String(content.year))년 \(content.month)월")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray05"))

                    Spacer().frame(height: 8)
                    HStack {
                        HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                            Text("\(content.totalSpending)원")
                                .font(.ButtonH4SemiboldFont())
                                .platformTextColor(color: Color("Gray07"))

                            if content.targetAmountDetail.amount != -1 {
                                DiffAmountDynamicWidthView(
                                    text: DiffAmountColorUtil.determineText(for: content.diffAmount),
                                    backgroundColor: DiffAmountColorUtil.determineBackgroundColor(for: content.diffAmount),
                                    textColor: DiffAmountColorUtil.determineTextColor(for: content.diffAmount)
                                )
                            }
                        }

                        Spacer()

                        Image("icon_arrow_front_small_gray03")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let components = DateComponents(year: content.year, month: content.month)
                        if let date = Calendar.current.date(from: components) {
                            currentMonth = date
                        }
                        navigateToMySpendingList = true
                    }
                }
            }
            .frame(height: 60 * DynamicSizeFactor.factor())
            .padding(.horizontal, 20)

            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
    }
}
