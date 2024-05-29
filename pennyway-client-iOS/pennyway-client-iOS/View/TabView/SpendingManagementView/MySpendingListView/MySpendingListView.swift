
import SwiftUI

// MARK: - MySpendingListView

struct MySpendingListView: View {
    @ObservedObject var viewModel: MySpendingListViewModel
    var listItem: [MySpendingHistoryListItem]

    let categories = [
        ("icon_category_food_on", "식비"),
        ("icon_category_traffic_on", "교통"),
        ("icon_category_beauty_on", "미용/패션"),
        ("icon_category_market_on", "편의점/마트"),
        ("icon_category_education_on", "교육"),
        ("icon_category_life_on", "생활"),
        ("icon_category_health_on", "건강"),
        ("icon_category_hobby_on", "취미/여가"),
        ("icon_category_travel_on", "여행/숙박"),
        ("icon_category_drink_on", "술/유흥"),
        ("icon_category_event_on", "회비/경조사"),
        ("icon_category_plus_off", "추가하기")
    ]

    var body: some View {
        NavigationAvailable {
            ZStack(alignment: .leading) {
                VStack(spacing: 36 * DynamicSizeFactor.factor()) {
                    SpendingWeekCalendarView(viewModel: viewModel)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0 * DynamicSizeFactor.factor()) {
                            ForEach(listItem.groupedByDate(), id: \.key) { group in
                                Section(header: headerView(for: group.key)) {
                                    ForEach(group.values) { item in
                                        ExpenseRow(expense: item, categories: categories)
                                        Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                    }
                                }
                            }
                            Spacer().frame(height: 16 * DynamicSizeFactor.factor()) // 패딩값 수정 필요해보임
                        }
                    }
                }
                //            .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역")
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
        .bottomSheet(isPresented: $viewModel.isChangeMonth, maxHeight: 384 * DynamicSizeFactor.factor()) {
            ChangeMonthContentView(viewModel: viewModel, isPresented: $viewModel.isChangeMonth)
        }
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
    }

    private func headerView(for date: Date) -> some View {
        Text(itemFormatter.string(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MMMM d일"
        return formatter
    }()
}

extension Sequence where Iterator.Element == MySpendingHistoryListItem {
    func groupedByDate() -> [(key: Date, values: [MySpendingHistoryListItem])] {
        let grouped = Dictionary(grouping: self, by: { Calendar.current.startOfDay(for: $0.date) })
        return grouped.map { (key: $0.key, values: $0.value) }.sorted { $0.key > $1.key }
    }
}

// MARK: - ExpenseRow

struct ExpenseRow: View {
    var expense: MySpendingHistoryListItem
    let categories: [(iconName: String, title: String)]
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Image("\(categoryIconName)")
                    .resizable()
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                Text(expense.category)
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))

                Spacer()

                Text("\(expense.amount)원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))
            }
        }
        .padding(.horizontal, 20)
    }

    private var categoryIconName: String {
        categories.first { $0.title == expense.category }?.iconName ?? "default_icon_name" // 이렇게 안해주니까 preview crashed 발생
    }
}

// MARK: - MySpendingListView_Previews

struct MySpendingListView_Previews: PreviewProvider {
    static var previews: some View {
        MySpendingListView(
            viewModel: MySpendingListViewModel(),
            listItem: [
                MySpendingHistoryListItem(category: "식비", amount: 32000, date: Date()),
                MySpendingHistoryListItem(category: "교통", amount: 8000, date: Date()),
                MySpendingHistoryListItem(category: "쇼핑", amount: 15000, date: Date())
            ]
        )
    }
}
