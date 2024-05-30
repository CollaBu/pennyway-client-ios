
import SwiftUI

// MARK: - MySpendingListView

struct MySpendingListView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

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
        ZStack(alignment: .leading) {
            VStack(spacing: 36 * DynamicSizeFactor.factor()) {
                SpendingWeekCalendarView(spendingHistoryViewModel: spendingHistoryViewModel)

                ScrollView {
                    LazyVStack(spacing: 0 * DynamicSizeFactor.factor()) {
                        ForEach(groupedSpendings(), id: \.key) { date, spendings in
                            Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                            Section(header: headerView(for: date)) {
                                Spacer().frame(height: 8 * DynamicSizeFactor.factor())
                                ForEach(spendings, id: \.id) { item in
                                    ExpenseRow(category: item.category.name, amount: item.amount, memo: item.memo, categories: categories)
                                    Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                }
                                .onAppear {
                                    Log.debug("spendings: \(spendings)")
                                    Log.debug("group: \(groupedSpendings())")
                                }
                            }
                        }
                        Spacer().frame(height: 16 * DynamicSizeFactor.factor())

                        Button(action: {}, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 103 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: Color("Gray01"))
                                    .cornerRadius(26)

                                Text("5월 내역 보기")
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: Color("Gray04"))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                            }
                        })

                        Spacer().frame(height: 48 * DynamicSizeFactor.factor())
                    }
                }
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역")
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
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
        .bottomSheet(isPresented: $spendingHistoryViewModel.isChangeMonth, maxHeight: 384 * DynamicSizeFactor.factor()) {
            ChangeMonthContentView(viewModel: spendingHistoryViewModel, isPresented: $spendingHistoryViewModel.isChangeMonth)
        }
        .onAppear {
            spendingHistoryViewModel.checkSpendingHistoryApi { success in
                if success {
                    Log.debug("소비내역 조회 api 연동 성공")
                } else {
                    Log.debug("소비내역 조회 api 연동 실패")
                }
            }
        }
    }

    private func headerView(for date: String) -> some View {
        Text(dateFormatter(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    ///    private let itemFormatter: DateFormatter = {
    ///        let formatter = DateFormatter()
    ///        formatter.locale = Locale(identifier: "ko_KR")
    ///        formatter.dateFormat = "MMMM d일"
    ///        return formatter
    ///    }()
    private func dateFormatter(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }

    private func groupedSpendings() -> [(key: String, values: [IndividualSpending])] {
//            let allSpendings = spendingHistoryViewModel.dailyDetailSpendings.flatMap { $0.spendAt }
        let grouped = Dictionary(grouping: spendingHistoryViewModel.dailyDetailSpendings, by: { dateFormatter(from: $0.spendAt) })

        Log.debug("??????: \(grouped)")

        let group = grouped.map { (key: $0.key, values: $0.value) }
        return group.sorted { $0.key > $1.key }
    }
}

// MARK: - ExpenseRow

// extension Sequence where Iterator.Element == DailySpending {
//    func groupedByDate() -> [(key: Date, values: [DailySpending])] {
//        let grouped = Dictionary(grouping: self, by: { Calendar.current.startOfDay(for: $0.day) })
//        return grouped.map { (key: $0.key, values: $0.value) }.sorted { $0.key > $1.key }
//    }
// }

struct ExpenseRow: View {
    var category: String
    var amount: Int
    var memo: String
    ///    var expense: MySpendingHistoryListItem
    let categories: [(iconName: String, title: String)]
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Image("\(categoryIconName)")
                    .resizable()
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                Text(category)
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))

                // 메모 추가해야함

                Spacer()

                Text("\(amount)원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))
            }
        }
        .padding(.horizontal, 20)
    }

    private var categoryIconName: String {
        categories.first { $0.title == category }?.iconName ?? "default_icon_name" // 나중에 빈 값 넘겨주도록 수정
    }
}

// MARK: - MySpendingListView_Previews

struct MySpendingListView_Previews: PreviewProvider {
    static var previews: some View {
        MySpendingListView(
            spendingHistoryViewModel: SpendingHistoryViewModel())
    }
}
