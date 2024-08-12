import SwiftUI

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @State private var clickDate: Date? = nil
    @State private var spendingId: Int? = nil
    @State private var showDetailSpendingView = false
    @Binding var showDeleteToastPopup: Bool
    @Binding var isDeleted: Bool

    var currentYear = String(Date.year(from: Date()))

    var body: some View {
        ZStack {
            LazyVStack(spacing: 0) {
                ForEach(SpendingListGroupUtil.groupedSpendings(from: viewModel.dailyDetailSpendings), id: \.key) { date, spendings in
                    VStack(spacing: 0) {
                        if DateFormatterUtil.getYear(from: date) != currentYear {
                            VStack(spacing: 0) {
                                Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                                yearSeparatorView(for: DateFormatterUtil.getYear(from: date))
                                    .padding(.horizontal, 20)
                                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                            }
                        } else {
                            Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                        }

                        Section(header: headerView(for: date)) {
                            Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                            ForEach(spendings, id: \.id) { item in
                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""

                                Button(action: {
                                    spendingId = item.id
                                    viewModel.dailyDetailSpendings = [item]
                                    showDetailSpendingView = true

                                }, label: {
                                    CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                        .contentShape(Rectangle())
                                })
                                .buttonStyle(PlainButtonStyle())
                                .buttonStyle(BasicButtonStyleUtil())

                                Spacer().frame(height: 6 * DynamicSizeFactor.factor())

                                    .onAppear {
                                        guard let index = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == item.id }) else {
                                            return
                                        }
                                        // 해당 index가 마지막 index라면 데이터 추가
                                        if index == viewModel.dailyDetailSpendings.count - 1 {
                                            Log.debug("지출 내역 index: \(index)")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 임시 버퍼링
                                                viewModel.getCategorySpendingHistoryApi { _ in }
                                            }
                                        }
                                    }
                            }
                        }

                        Spacer()
                    }
                }
                Spacer().frame(height: 18 * DynamicSizeFactor.factor())
            }
        }

        NavigationLink(destination: DetailSpendingView(clickDate: $clickDate, spendingId: $spendingId, isDeleted: $isDeleted, showToastPopup: $showDeleteToastPopup, spendingCategoryViewModel: viewModel), isActive: $showDetailSpendingView) {}
            .hidden()
    }

    private func headerView(for date: String) -> some View {
        Text(DateFormatterUtil.dateFormatString(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func yearSeparatorView(for year: String) -> some View {
        HStack {
            Rectangle()
                .fill(Color("Gray03"))
                .frame(height: 1 * DynamicSizeFactor.factor())
            Text("\(year)년")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .padding(.vertical, 9 * DynamicSizeFactor.factor())
            Rectangle()
                .fill(Color("Gray03"))
                .frame(height: 1 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
