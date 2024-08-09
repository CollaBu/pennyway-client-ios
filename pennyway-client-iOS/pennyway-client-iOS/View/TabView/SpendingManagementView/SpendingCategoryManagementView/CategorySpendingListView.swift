import SwiftUI

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @State private var clickDate: Date? = nil
    @State private var spendingId: Int? = nil
    @State private var showDetailSpendingView = false
    @State private var needRefresh = false
    @Binding var showToastPopup: Bool
    @Binding var isDeleted: Bool

    @State private var isLoadingViewShown: Bool = false
    @State private var isReloadViewShown = false

    var currentYear = String(Date.year(from: Date()))

    var body: some View {
        ZStack {
            LazyVStack(spacing: 0) {
                ForEach(SpendingListGroupUtil.groupedByYear(from: viewModel.dailyDetailSpendings).sorted(by: { $0.key > $1.key }), id: \.key) { year, spendingsByYear in
                    VStack(spacing: 0) {
                        if year != currentYear {
                            VStack(spacing: 0) {
                                Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                                yearSeparatorView(for: year)
                                    .padding(.horizontal, 20)
                                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                            }
                        }

                        ForEach(spendingsByYear, id: \.key) { date, spendings in
                            Section(header: headerView(for: date)) {
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                    ForEach(spendings, id: \.id) { item in
                                        let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""

                                        Button(action: {
                                            spendingId = item.id
//                                            viewModel.dailyDetailSpendings = [item] 셀 선택 후 뒤로가기시 리스트 데이터 사라지는 문제 해결
                                            showDetailSpendingView = true
                                        }, label: {
                                            CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                                .contentShape(Rectangle())
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                        .onAppear {
                                            handleOnAppear(for: item)
                                        }
                                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
                if isLoadingViewShown {
                    LoadingView(startAnimate: $isLoadingViewShown)
                }

                if isReloadViewShown {
                    ReloadView(action: reloadAction)
                }

                Spacer().frame(height: 18 * DynamicSizeFactor.factor())
            }
        }

        NavigationLink(destination: DetailSpendingView(clickDate: $clickDate, spendingId: $spendingId, isDeleted: $isDeleted, showToastPopup: $showToastPopup, spendingCategoryViewModel: viewModel), isActive: $showDetailSpendingView) {}
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

    private func handleOnAppear(for item: IndividualSpending) {
        guard let currentIndex = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        Log.debug(currentIndex)

        if currentIndex == viewModel.dailyDetailSpendings.count - 1 && !isLoadingViewShown {
            Log.debug("지출 내역 index: \(currentIndex)")

            if viewModel.hasNext {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoadingViewShown = true
                }
            }

            handleApiResponse()
        } else {
            isLoadingViewShown = false
        }
    }

    private func handleApiResponse() {
        if viewModel.hasNext {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoadingViewShown = true
            }
        }

        var timeout = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if !timeout {
                Log.debug("API 응답이 10초 이상 걸림")
                isLoadingViewShown = false
                isReloadViewShown = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            viewModel.getCategorySpendingHistoryApi { success in
                timeout = true // 응답이 왔으므로 타이머 취소
                if success {
                    isLoadingViewShown = false
                    Log.debug("지출 내역 가져오기 성공 후 로딩 뷰 사라짐")
                }
            }
        }
    }

    private func reloadAction() {
        isLoadingViewShown = true
        isReloadViewShown = false

        handleApiResponse()
    }
}
