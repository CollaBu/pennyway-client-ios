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
    @StateObject var spendingCategoryViewModel = SpendingCategoryViewModel()
    @State var selectedDateToScroll: String? = nil
    @State private var currentMonth: Date = Date()
    @State private var navigateToCategoryGridView = false

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
                                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                                                NavigationLink(destination: DetailSpendingView()) {
                                                    CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                                }

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
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())

                }.offset(x: -10)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        navigateToCategoryGridView = true
                        spendingCategoryViewModel.getSpendingCustomCategoryListApi { _ in }
                    }, label: {
                        Text("카테고리")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                    })
                    .padding(.trailing, 20)
                    .frame(width: 38 * DynamicSizeFactor.factor(), height: 44)
                }
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

        NavigationLink(destination: SpendingCategoryGridView(SpendingCategoryViewModel: spendingCategoryViewModel, addSpendingHistoryViewModel: AddSpendingHistoryViewModel()), isActive: $navigateToCategoryGridView) {}
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

// MARK: - MySpendingListView_Previews

struct MySpendingListView_Previews: PreviewProvider {
    static var previews: some View {
        MySpendingListView(
            spendingHistoryViewModel: SpendingHistoryViewModel()
        )
    }
}
