import SwiftUI

// MARK: - MySpendingListView

//// MARK: - SpendingListID
//
// struct SpendingListID: Identifiable {
//    let id: Int
//    let description: String
//    // 필요한 다른 속성 추가
// }

struct MySpendingListView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @State var selectedDateToScroll: String? = nil
    @State private var currentMonth: Date = Date()
    @State private var buttonTitle: String = "5월 내역 보기"

    let categories: [String: String] = [
        "FOOD": "icon_category_food_on",
        "TRANSPORTATION": "icon_category_traffic_on",
        "BEAUTY_OR_FASHION": "icon_category_beauty_on",
        "CONVENIENCE_STORE": "icon_category_market_on",
        "EDUCATION": "icon_category_education_on",
        "LIVING": "icon_category_life_on",
        "HEALTH": "icon_category_health_on",
        "HOBBY": "icon_category_hobby_on",
        "TRAVEL": "icon_category_travel_on",
        "ALCOHOL_OR_ENTERTAINMENT": "icon_category_drink_on",
        "MEMBERSHIP_OR_FAMILY_EVENT": "icon_category_event_on",
        "OTHER": "icon_category_plus_off"
    ]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 40 * DynamicSizeFactor.factor()) {
                SpendingWeekCalendarView(
                    spendingHistoryViewModel: spendingHistoryViewModel,
                    selectedDateToScroll: $selectedDateToScroll
                )

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            if groupedSpendings().isEmpty {
                                NoSpendingHistoryView()
                            } else {
                                LazyVStack(spacing: 0 * DynamicSizeFactor.factor()) {
                                    ForEach(groupedSpendings(), id: \.key) { date, spendings in
                                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                                        Section(header: headerView(for: date)) {
                                            Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                            ForEach(spendings, id: \.id) { item in
                                                let iconName = categories[item.category.icon] ?? ""
                                                ExpenseRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                            }
                                            .onAppear {
                                                Log.debug("spendings: \(spendings)")
                                                Log.debug("group: \(groupedSpendings())")
                                            }
                                        }
                                        .id(date) // ScrollViewReader를 위한 ID 추가
                                    }
                                    Spacer().frame(height: 18 * DynamicSizeFactor.factor())
                                }
                            }
                        }
                        if !groupedSpendings().isEmpty {
                            Button(action: {
                                changeMonth(by: -1)

                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 103 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                        .foregroundColor(Color("Gray01"))
                                        .cornerRadius(26)

                                    Text(monthTitle(from: spendingHistoryViewModel.currentDate))
                                        .font(.B1SemiboldeFont())
                                        .foregroundColor(Color("Gray04"))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                }
                            })
                            .padding(.bottom, 48)
                            .onChange(of: selectedDateToScroll) { date in
                                if let date = date {
                                    withAnimation {
                                        proxy.scrollTo(date, anchor: .top)
                                    }
                                }
                            }
                            .onAppear {
                                proxy.scrollTo(selectedDateToScroll, anchor: .top)
                            }
                        }
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
                NavigationBackButton()
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .offset(x: -15 * DynamicSizeFactor.factor())
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

    private func dateFormatter(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }

    /// 받아온 날짜가 string이기 때문에 날짜 문자열을 Date객체로 변환
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }

    private func groupedSpendings() -> [(key: String, values: [IndividualSpending])] {
        let grouped = Dictionary(grouping: spendingHistoryViewModel.dailyDetailSpendings, by: { String($0.spendAt.prefix(10)) })
        let sortedGroup = grouped.map { (key: $0.key, values: $0.value) }
            .sorted { group1, group2 -> Bool in
                if let date1 = dateFromString(group1.key + " 00:00:00"), let date2 = dateFromString(group2.key + " 00:00:00") {
                    return date1 > date2
                }
                return false
            }

        return sortedGroup
    }

    private func changeMonth(by value: Int) {
        let newDate = Calendar.current.date(byAdding: .month, value: value, to: spendingHistoryViewModel.currentDate) ?? currentMonth
        currentMonth = spendingHistoryViewModel.currentDate
        spendingHistoryViewModel.currentDate = newDate
        currentMonth = newDate

        spendingHistoryViewModel.checkSpendingHistoryApi { success in
            if success {
                Log.debug("지출내역 조회 API 연동 성공")
                DispatchQueue.main.async {
                    self.currentMonth = newDate
                }
            } else {
                Log.fault("지출내역 조회 API 연동 실패")
            }
        }
    }

    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 내역보기"
        if let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: date) {
            return dateFormatter.string(from: previousMonthDate)
        }
        return dateFormatter.string(from: date)
    }
}

// MARK: - ExpenseRow

struct ExpenseRow: View {
    var categoryIcon: String
    var category: String
    var amount: Int
    var memo: String

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                Image(categoryIcon)
                    .resizable()
                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())

                VStack(alignment: .leading, spacing: 1) { // Spacer는 Line heigth 적용하면 없애기
                    if memo.isEmpty {
                        Text(category)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray06"))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(category)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray06"))
                            .multilineTextAlignment(.leading)

                        Text(memo)
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                Text("\(amount)원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray06"))
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - MySpendingListView_Previews

struct MySpendingListView_Previews: PreviewProvider {
    static var previews: some View {
        MySpendingListView(
            spendingHistoryViewModel: SpendingHistoryViewModel()
        )
    }
}
