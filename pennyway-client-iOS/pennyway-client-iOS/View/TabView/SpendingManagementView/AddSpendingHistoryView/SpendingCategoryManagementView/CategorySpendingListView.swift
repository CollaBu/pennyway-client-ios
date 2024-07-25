
import SwiftUI

struct CategorySpendingListView: View {
    @ObservedObject var viewModel: SpendingCategoryViewModel
    @State private var clickDate: Date? = nil
    @State private var isLoadingViewShown: Bool = false
    @State private var isLoading = false

    var currentYear = String(Date.year(from: Date()))
                
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(SpendingListGroupUtil.groupedSpendings(from: viewModel.dailyDetailSpendings), id: \.key) { date, spendings in
                            
                if DateFormatterUtil.getYear(from: date) != currentYear {
                    yearSeparatorView(for: DateFormatterUtil.getYear(from: date))
                        .padding(.horizontal, 20)
                                
                    Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                }
                            
                Section(header: headerView(for: date)) {
                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    ForEach(spendings, id: \.id) { item in
                        let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                        NavigationLink(destination: DetailSpendingView(clickDate: $clickDate)) {
                            CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            guard var currentIndex = viewModel.dailyDetailSpendings.firstIndex(where: { $0.id == item.id }) else {
                                return
                            }
                            Log.debug(currentIndex)
                            
                            if currentIndex == viewModel.dailyDetailSpendings.count - 1 && !isLoadingViewShown {
                                Log.debug("지출 내역 index: \(currentIndex)")
                                
                                if viewModel.hasNext {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {//
                                        isLoadingViewShown = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    viewModel.getCategorySpendingHistoryApi { success in
                                        if success {
                                            isLoadingViewShown = false
                                            Log.debug("지출 내역 가져오기 성공 후 로딩 뷰 사라짐")             
                                            currentIndex = viewModel.dailyDetailSpendings.count - 1
                                        }
                                    }
                                }
                            }
                        }
                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                    }
                }
                
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
            }
            if isLoadingViewShown {
                LoadingView()
            }
        }
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
