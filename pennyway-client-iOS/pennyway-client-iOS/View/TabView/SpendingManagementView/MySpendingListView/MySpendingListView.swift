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
    @Binding var clickDate: Date?
    @State private var navigateToCategoryGridView = false
    @State private var showDetailSpendingView = false
    @State private var selectedSpendingId: Int? = nil

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
                            if SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings).isEmpty {
                                NoSpendingHistoryView(spendingHistoryViewModel: spendingHistoryViewModel, clickDate: $clickDate)
                            } else {
                                LazyVStack(spacing: 0 * DynamicSizeFactor.factor()) {
                                    ForEach(SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings), id: \.key) { date, spendings in

                                        Spacer().frame(height: 10 * DynamicSizeFactor.factor())

                                        Section(header: headerView(for: date)) {
                                            Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                            ForEach(spendings, id: \.id) { item in
                                                let iconName = SpendingListViewCategoryIconList(rawValue: item.category.icon)?.iconName ?? ""
                                                Button(action: {
                                                    clickDate = DateFormatterUtil.parseDate(from: date)
                                                    spendingHistoryViewModel.selectedDate = clickDate
                                                    showDetailSpendingView = true
                                                }, label: {
                                                    CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)

                                                })
                                                .buttonStyle(PlainButtonStyle()) 

                                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                            }
                                            .onAppear {
                                                Log.debug("spendings: \(spendings)")
                                                Log.debug("group: \(SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings))")
                                            }
                                        }
                                        .id(date) // ScrollViewReader를 위한 ID 추가
                                    }
                                    Spacer().frame(height: 18 * DynamicSizeFactor.factor())
                                }
                            }
                        }
                        if !SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings).isEmpty {
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

            NavigationLink(destination: DetailSpendingView(clickDate: $clickDate), isActive: $showDetailSpendingView) {}
        }
        .navigationBarColor(UIColor(named: "White01"), title: "소비 내역")
        .edgesIgnoringSafeArea(.bottom)
        .frame(maxHeight: .infinity)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
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
        Text(DateFormatterUtil.dateFormatString(from: date))
            .font(.B2MediumFont())
            .platformTextColor(color: Color("Gray04"))
            .padding(.leading, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
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
