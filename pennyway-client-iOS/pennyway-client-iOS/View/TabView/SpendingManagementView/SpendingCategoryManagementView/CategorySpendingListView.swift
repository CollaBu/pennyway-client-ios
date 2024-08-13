import SwiftUI

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @State private var clickDate: Date? = nil
    @State private var spendingId: Int? = nil
    @State private var showDetailSpendingView = false
    @Binding var showDeleteToastPopup: Bool
    @Binding var isDeleted: Bool

    @State private var isLoadingViewShown: Bool = false
    @State private var animateLoadingView: Bool = false
    @State private var isReloadViewShown = false

    var currentYear = String(Date.year(from: Date()))

    var body: some View {
        ZStack {
            LazyVStack(spacing: 0) {
                ForEach(SpendingListGroupUtil.groupedByYear(from: viewModel.dailyDetailSpendings).sorted(by: { $0.key > $1.key }), id: \.key) { year, spendingsByYear in
                    VStack(spacing: 0) {
                        if year != currentYear {
                            yearSeparatorView(for: year)
                                .padding(.horizontal, 20)
                        }

                        ForEach(spendingsByYear, id: \.key) { date, spendings in

                            Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                            Section(header: headerView(for: date)) {
                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                ForEach(spendings, id: \.id) { item in
                                    let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""

                                    Button(action: {
                                        spendingId = item.id
                                        viewModel.selectSpending = item
                                        showDetailSpendingView = true
                                    }, label: {
                                        CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                            .contentShape(Rectangle())
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .buttonStyle(BasicButtonStyleUtil())

                                    .onAppear {
                                        handleOnAppear(for: item)
                                    }

                                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                }
                            }
                        }
                    }
                }
                if isLoadingViewShown {
                    LoadingView(startAnimate: $animateLoadingView)
                }

                if isReloadViewShown {
                    ReloadView(action: reloadAction)
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

    private func handleOnAppear(for item: IndividualSpending) {
        guard let currentIndex = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        if currentIndex == viewModel.dailyDetailSpendings.count - 1 && !isLoadingViewShown {
            Log.debug("지출 내역 index: \(currentIndex)")

            if viewModel.hasNext {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateLoadingView = true
                    isLoadingViewShown = true
                    startApiRetryTimer()
                }
            }

        } else {
            Log.debug("지출 내역 마지막 index")
            isLoadingViewShown = false
            isReloadViewShown = false
        }
    }

    private func startApiRetryTimer() {
        var retryWorkItem: DispatchWorkItem?

        // API 응답 10초 이상 걸린 경우
        retryWorkItem = DispatchWorkItem {
            Log.debug("API 응답이 10초 이상 걸림")

            // 로딩 뷰 사라지고, 재로드 뷰 나타남
            animateLoadingView = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoadingViewShown = false
                isReloadViewShown = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: retryWorkItem!)

        viewModel.getCategorySpendingHistoryApi { success in

            if success {
                // 로딩 뷰와 재로드 뷰 사라짐
                Log.debug("지출 내역 가져오기 성공 후 로딩 뷰 사라짐")
                animateLoadingView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoadingViewShown = false
                    isReloadViewShown = false
                }
            } else {
                // 로딩 뷰 사라지고, 재로드 뷰 나타남
                Log.debug("API 호출 실패, 재로드 뷰 나타남")
                animateLoadingView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoadingViewShown = false
                    isReloadViewShown = true
                }
            }

            retryWorkItem?.cancel() // 타이머 리셋
        }
    }

    private func reloadAction() {
        // 로딩 뷰 나오고, 재로드 뷰 사라짐
        animateLoadingView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isLoadingViewShown = true
            isReloadViewShown = false
        }

        startApiRetryTimer()
    }
}
