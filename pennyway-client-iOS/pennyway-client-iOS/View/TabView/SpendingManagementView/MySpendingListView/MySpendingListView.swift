import SwiftUI

// MARK: - MySpendingListView

struct MySpendingListView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @StateObject var spendingCategoryViewModel = SpendingCategoryViewModel()
    @State var selectedDateToScroll: String? = nil
    @Binding var currentMonth: Date
    @Binding var clickDate: Date?
    @State private var navigateToCategoryGridView = false
    @State private var showDetailSpendingView = false
    @State private var selectedSpendingId: Int? = nil
    @State private var showToastPopup = false
    @State private var isDeleted = false

    @State var lastSelectedDate: Date? = nil
    @State var lastSelectedMonth: Date? = nil

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
                                                    Log.debug("버튼 누름")
                                                    clickDate = DateFormatterUtil.parseDate(from: date)
                                                    spendingHistoryViewModel.selectedDate = clickDate
                                                    selectedSpendingId = item.id
                                                    Log.debug("Id: \(selectedSpendingId), clickDate: \(clickDate)")
                                                    showDetailSpendingView = true
                                                    spendingHistoryViewModel.isClickSpendingDetailView = true

                                                    // 상세 화면으로 이동하기 전에 상태 보존
                                                    lastSelectedDate = spendingHistoryViewModel.selectedDate
                                                    lastSelectedMonth = spendingHistoryViewModel.currentDate

                                                }, label: {
                                                    CustomSpendingRow(categoryIcon: iconName, category: item.category.name, amount: item.amount, memo: item.memo)
                                                        .contentShape(Rectangle())

                                                })
                                                .buttonStyle(PlainButtonStyle())
                                                .buttonStyle(BasicButtonStyleUtil())

                                                Spacer().frame(height: 12 * DynamicSizeFactor.factor())
                                            }
                                            .onAppear {
                                                Log.debug("spendings: \(spendings)")
                                                Log.debug("group: \(SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings))")
                                            }
                                        }
                                        .id(date) // ScrollViewReader를 위한 ID 추가
                                    }
                                }

                                Spacer().frame(height: 18 * DynamicSizeFactor.factor())
                            }
                        }
                        .analyzeEvent(SpendingEvents.mySpendingListView, additionalParams: [AnalyticsConstants.Parameter.date: currentMonth])

                        if !SpendingListGroupUtil.groupedSpendings(from: spendingHistoryViewModel.dailyDetailSpendings).isEmpty {
                            Button(action: {
                                changeMonth(by: -1)
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 103 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                        .platformTextColor(color: Color("Gray01"))
                                        .cornerRadius(26)

                                    Text(monthTitle(from: spendingHistoryViewModel.currentDate))
                                        .font(.B1SemiboldeFont())
                                        .platformTextColor(color: Color("Gray04"))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                }
                            })
                            .buttonStyle(BasicButtonStyleUtil())
                            .buttonStyle(PlainButtonStyle())
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
            .overlay(
                Group {
                    if showToastPopup {
                        CustomToastView(message: "소비 내역을 삭제했어요")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.2)) // 애니메이션 시간
                            .padding(.bottom, 34 * DynamicSizeFactor.factor())
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToastPopup = false
                                    }
                                }
                            }
                    }
                }, alignment: .bottom
            )

            NavigationLink(destination: DetailSpendingView(clickDate: $clickDate, spendingId: $selectedSpendingId, isDeleted: $isDeleted, showToastPopup: $showToastPopup, isEditSuccess: .constant(false), isAddSpendingData: .constant(false), spendingCategoryViewModel: SpendingCategoryViewModel()), isActive: $showDetailSpendingView) {}
                .hidden()
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
                        spendingCategoryViewModel.getSpendingCustomCategoryListApi { success in
                            if success {
                                navigateToCategoryGridView = true
                            }
                        }
                    }, label: {
                        Text("카테고리")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))

                    })
                    .buttonStyle(BasicButtonStyleUtil())
                    .frame(width: 48 * DynamicSizeFactor.factor(), height: 44)
                }
            }
        }
        .bottomSheet(isPresented: $spendingHistoryViewModel.isChangeMonth, maxHeight: 384 * DynamicSizeFactor.factor()) {
            ChangeMonthContentView(viewModel: spendingHistoryViewModel, isPresented: $spendingHistoryViewModel.isChangeMonth)
        }
        .onAppear {
            if let lastMonth = lastSelectedMonth {
                // 이전에 선택한 달이 있으면 해당 달로 이동
                spendingHistoryViewModel.currentDate = lastMonth
                currentMonth = lastMonth
            } else {
                // 그렇지 않으면 현재 달을 사용
                spendingHistoryViewModel.currentDate = currentMonth
            }

            spendingHistoryViewModel.checkSpendingHistoryApi { success in
                if success {
                    Log.debug("소비내역 조회 api 연동 성공")
                } else {
                    Log.debug("소비내역 조회 api 연동 실패")
                }
            }

            if let lastDate = lastSelectedDate {
                // 이전에 선택한 날짜가 있으면 해당 날짜로 스크롤
                selectedDateToScroll = DateFormatterUtil.dateFormatter(date: lastDate)
                Log.debug("이전에 선택한 날짜가 있음")
            }
        }

        NavigationLink(destination: SpendingCategoryGridView(spendingCategoryViewModel: spendingCategoryViewModel, addSpendingHistoryViewModel: AddSpendingHistoryViewModel()), isActive: $navigateToCategoryGridView) {}
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

    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 내역보기"
        if let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: date) {
            return dateFormatter.string(from: previousMonthDate)
        }
        return dateFormatter.string(from: date)
    }

    /// 스크롤 바 하단 M월 내역보기 버튼 클릭시 이전달로 이동하는 함수
    private func changeMonth(by value: Int) {
        let newDate = Calendar.current.date(byAdding: .month, value: value, to: spendingHistoryViewModel.currentDate) ?? currentMonth
        currentMonth = spendingHistoryViewModel.currentDate
        spendingHistoryViewModel.currentDate = newDate
        currentMonth = newDate

        // 현재 날짜가 새로운 달에 속하는지 확인
        let calendar = Calendar.current
        let newMonthComponents = calendar.dateComponents([.year, .month], from: newDate)
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month], from: today)

        if newMonthComponents == todayComponents {
            // 새로운 달이 현재 달이면 오늘 날짜로 설정
            spendingHistoryViewModel.selectedDate = today
            selectedDateToScroll = DateFormatterUtil.dateFormatter(date: today)
        } else {
            // 그렇지 않으면 새로운 달의 1일로 설정
            let firstDayOfMonth = calendar.date(from: newMonthComponents)!
            spendingHistoryViewModel.selectedDate = firstDayOfMonth
            selectedDateToScroll = DateFormatterUtil.dateFormatter(date: firstDayOfMonth)
        }

        spendingHistoryViewModel.selectedDate = nil
        spendingHistoryViewModel.selectedDateId = 0

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
}
