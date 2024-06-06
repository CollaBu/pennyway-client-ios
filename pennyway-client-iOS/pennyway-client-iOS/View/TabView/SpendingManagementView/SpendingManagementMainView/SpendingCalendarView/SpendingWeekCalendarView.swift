import SwiftUI

// MARK: - SpendingWeekCalendarView

struct SpendingWeekCalendarView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var date: Date = Date()
    @State private var changeMonth = false
    @State private var proxy: ScrollViewProxy?

    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel
    @Binding var selectedDateToScroll: String?

    private let calendar = Calendar.current
    ///    let dailyTotalAmount = getSpendingAmount(for: day)
    var checkChangeMonth = false

    init(
        spendingHistoryViewModel: SpendingHistoryViewModel,
        selectedDateToScroll: Binding<String?>
    ) {
        self.spendingHistoryViewModel = spendingHistoryViewModel
        _selectedDateToScroll = selectedDateToScroll
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            VStack(alignment: .leading, spacing: 20 * DynamicSizeFactor.factor()) {
                monthView

                ZStack(alignment: .top) {
                    dayView
                }
                .frame(height: 40 * DynamicSizeFactor.factor())
                .padding(.horizontal, 10)
            }
            .padding(.top, 8)
            .onChange(of: spendingHistoryViewModel.selectedDateToScroll) { newValue in
                if let newDateStr = newValue, let date = parseDate(from: newDateStr) {
                    selectedDate = date
                    withAnimation {
                        scrollProxy.scrollTo(date, anchor: .center)
                    }
                }
            }
            .onAppear {
                proxy = scrollProxy
            }
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

    // MARK: - 월 표시 뷰

    private var monthView: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                Button(action: {
                    spendingHistoryViewModel.isChangeMonth = true
                }, label: {
                    HStack(spacing: 0) {
                        Text(monthTitle(from: spendingHistoryViewModel.currentDate))
                            .font(.ButtonH4SemiboldFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(1)

                        Image("icon_arrow_down_rect")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .aspectRatio(contentMode: .fill)
                            .padding(.trailing, 7)
                    }
                    .padding(.vertical, 8)
                })
                .buttonStyle(PlainButtonStyle())

                Spacer()

                HStack(spacing: 16 * DynamicSizeFactor.factor()) {
                    Button(
                        action: {
                            changeMonth(by: -1)
                        },
                        label: {
                            Image("icon_arrow_back_small")
                                .frame(width: 24, height: 24 * DynamicSizeFactor.factor())
                                .aspectRatio(contentMode: .fill)
                        }
                    )

                    Button(
                        action: {
                            changeMonth(by: 1)
                        },
                        label: {
                            Image(!canMoveToNextMonth() ? "icon_arrow_front_small_off" : "icon_arrow_front_small")
                                .frame(width: 24, height: 24 * DynamicSizeFactor.factor())
                                .aspectRatio(contentMode: .fill)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 일자 표시 뷰

    @ViewBuilder
    private var dayView: some View {
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
//                ScrollViewReader { pro in
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                let components = (
                    0 ..< calendar.range(of: .day, in: .month, for: startDate)!.count)
                    .map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }

                ForEach(components, id: \.self) { date in
                    VStack {
                        Text(day(from: date))
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray04"))

                        Spacer().frame(height: 9) // 동적 ui 적용하니 너무 넓어짐

                        Text("\(calendar.component(.day, from: date))")
                            .font(.B2MediumFont())
                            .frame(width: 23 * DynamicSizeFactor.factor(), height: 26 * DynamicSizeFactor.factor())
                            .background(
                                Circle()
                                    .platformTextColor(color: circleColor(for: date))
                            )
                            .platformTextColor(color: textColor(for: date))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)

                        Spacer().frame(height: 4) // 동적 ui 적용하니 너무 넓어짐

                        if let amount = getSpendingAmount(for: date) {
                            Text("-\(amount)")
                                .font(.B4MediumFont())
                                .platformTextColor(color: calendar.isDateInToday(date) ? Color("Mint03") : Color("Gray06"))
                        } else {
                            Text("")
                        }
                    }
                    .onTapGesture {
                        if !calendar.isDateInFuture(date, comparedTo: self.date) {
                            selectedDate = date
                            selectedDateToScroll = dateFormatter(date: date)
                            spendingHistoryViewModel.selectedDateToScroll = dateFormatter(date: date)
                        }
                    }
                    .frame(height: 65 * DynamicSizeFactor.factor())
                }
                .id(date)
            }
            .padding(.top, 20)
        }
    }

    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func getSpendingAmount(for date: Date) -> Int? {
        let day = calendar.component(.day, from: date)
        return spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }

    private func circleColor(for date: Date) -> Color {
        if calendar.isDateInToday(date) {
            return Color("Mint01")
        } else if spendingHistoryViewModel.getDailyTotalAmount(for: date) == nil {
            return Color.clear
        }

        else if calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) {
            return spendingHistoryViewModel.getDailyTotalAmount(for: date) == nil ? Color("Gray02") : Color("Gray03")
        } else {
            return Color.clear
        }
    }

    private func textColor(for date: Date) -> Color {
        if calendar.isDateInToday(date) {
            return Color("Mint03")
        } else if spendingHistoryViewModel.getDailyTotalAmount(for: date) == nil {
            return Color("Gray03")
        } else if calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) {
            return spendingHistoryViewModel.getDailyTotalAmount(for: date) == nil ? Color("Gray04") : Color("Gray05")
        } else {
            return Color("Gray06")
        }
    }

    private func dateRange(for startOfWeek: Date) -> [Date] {
        var dates = [Date]()
        for i in 0 ..< 7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }

    private func parseDate(from dateString: String) -> Date? { // 지출 리스트에서 스크롤된 날짜를 감지하기 위해 date를 반환하는 함수
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    private func getSpendingAmount(for day: Int) -> Int? {
        return spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.dailyTotalAmount
    }
}

// MARK: - 로직

private extension SpendingWeekCalendarView {
    /// 월 표시
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: date)
    }

    // MARK: - 월 변경

    func changeMonth(by value: Int) {
        let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) ?? selectedDate
        selectedDate = newDate
        spendingHistoryViewModel.currentDate = selectedDate

        spendingHistoryViewModel.checkSpendingHistoryApi { success in
            if success {
                Log.debug("지출내역 조회 API 연동 성공")
                DispatchQueue.main.async {
                    self.selectedDate = newDate
                }
            } else {
                Log.fault("지출내역 조회 API 연동 실패")
            }
        }
    }

    /// 요일 추출
    func day(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    /// 이전 월로 이동 가능한지 확인
    func canMoveToPreviousMonth() -> Bool {
        let calendar = Calendar.current

        // 2000년 1월 1일을 생성
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        guard let targetDate = calendar.date(from: components) else {
            return false
        }

        // 이전 월이 targetDate(2000년 1월 1일)보다 크거나 같으면 이동 가능
        if adjustedMonth(by: -1) >= targetDate {
            return true
        } else {
            return false
        }
    }

    /// 다음 월로 이동 가능한지 확인
    ///    private func canMoveToNextMonth() -> Bool {
    ///        let currentDate = Date()
    ///        let calendar = Calendar.current
    ///
    ///        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: currentDate) else {
    ///            return false
    ///        }
    ///        if nextMonthDate > currentDate {
    ///            return false
    ///        }
    ///
    ///        return true
    ///    }
    private func canMoveToNextMonth() -> Bool {
        let calendar = Calendar.current

        // 현재 시스템 날짜
        let currentDate = Date()
        let currentMonthComponents = calendar.dateComponents([.year, .month], from: currentDate)
        guard let currentMonthDate = calendar.date(from: currentMonthComponents) else {
            return false
        }

        // 선택된 날짜의 월
        let selectedDateMonthComponents = calendar.dateComponents([.year, .month], from: selectedDate)
        guard let selectedMonthDate = calendar.date(from: selectedDateMonthComponents) else {
            return false
        }

        // 선택된 달이 현재 달이면 다음 달로 이동 불가
        return selectedMonthDate < currentMonthDate
    }

    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: date) {
            return newMonth
        }
        return date
    }
}

extension Calendar {
    func isDateInFuture(_ date: Date, comparedTo currentMonth: Date) -> Bool {
        let currentYearMonth = dateComponents([.year, .month], from: currentMonth)
        let dateYearMonth = dateComponents([.year, .month], from: date)
        if currentYearMonth == dateYearMonth {
            return date > Date()
        } else {
            return false
        }
    }
}

// MARK: - SpendingWeekCalendarView_Previews

#Preview {
    SpendingWeekCalendarView(spendingHistoryViewModel: SpendingHistoryViewModel(), selectedDateToScroll: .constant(nil))
}