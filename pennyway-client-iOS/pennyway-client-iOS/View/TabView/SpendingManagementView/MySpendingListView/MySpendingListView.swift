import SwiftUI

// MARK: - SpendingListID

struct SpendingListID: Identifiable {
    let id: Int
    let description: String
    // 필요한 다른 속성 추가
}

// MARK: - MySpendingListView

struct MySpendingListView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @State var selectedDateToScroll: String? = nil

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
                                LazyVStack(spacing: 0) {
                                    ForEach(groupedSpendings(), id: \.key) { date, spendings in
                                        Section(header: headerView(for: date)) {
                                            ForEach(spendings, id: \.id) { item in
                                                let iconName = categories[item.category.icon] ?? ""
                                                ExpenseRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                                    .id(date)
                                                    .onTapGesture {
                                                        spendingHistoryViewModel.selectedDateToScroll = date
                                                    }
                                            }
                                            Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                        }
                                    }
                                }
                            }
                        }
                        if !groupedSpendings().isEmpty {
                            Button(action: {
                                // 버튼 액션 추가
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 103 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                        .foregroundColor(Color("Gray01"))
                                        .cornerRadius(26)

                                    Text("5월 내역 보기")
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
