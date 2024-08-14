import SwiftUI

// MARK: - SpendingCalenderView

struct SpendingCalenderView: View {
    @ObservedObject var spendingHistoryViewModel: SpendingHistoryViewModel

    @Binding var showSpendingDetailView: Bool
    @State private var date: Date
    @State private var clickedCurrentMonthDates: Date?
    @Binding var clickDate: Date?

    let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    var checkChangeMonth = false
    
    init(spendingHistoryViewModel: SpendingHistoryViewModel, showSpendingDetailView: Binding<Bool>, date _: Binding<Date>, clickDate: Binding<Date?>) {
        self.spendingHistoryViewModel = spendingHistoryViewModel
        _showSpendingDetailView = showSpendingDetailView 
        _date = State(initialValue: spendingHistoryViewModel.currentDate)
        _clickDate = clickDate
    }
  
    var body: some View {
        VStack {
            Spacer().frame(height: 10 * DynamicSizeFactor.factor())
            
            headerView
            
            Spacer().frame(height: 10 * DynamicSizeFactor.factor())
            
            calendarGridView
                .padding(.horizontal, 11 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 16 * DynamicSizeFactor.factor())
        }
        .background(Color("White01"))
        .cornerRadius(8)
    }
  
    // MARK: - 헤더 뷰

    private var headerView: some View {
        VStack {
            yearMonthView
            
            Spacer().frame(height: 6 * DynamicSizeFactor.factor())
      
            HStack {
                ForEach(0 ..< 7, id: \.self) { index in
                    Text(self.weekdaySymbols[index])
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 11 * DynamicSizeFactor.factor())
        }
    }
  
    // MARK: - 연월 표시

    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 2 * DynamicSizeFactor.factor()) {
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image(!canMoveToPreviousMonth() ? "icon_calender_left_off" : "icon_calender_left_on")
                        .frame(width: 21 * DynamicSizeFactor.factor(), height: 21 * DynamicSizeFactor.factor())
                }
            )
            .frame(width: 44, height: 44)
            .disabled(!canMoveToPreviousMonth())
            .buttonStyle(BasicButtonStyleUtil())
      
            Text(date, formatter: Self.calendarHeaderDateFormatter)
                .font(.B1SemiboldeFont())
                .platformTextColor(color: Color("Gray07"))
      
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image(!canMoveToNextMonth() ? "icon_calender_right_off" : "icon_calender_right_on")
                        .frame(width: 21 * DynamicSizeFactor.factor(), height: 21 * DynamicSizeFactor.factor())
                }
            )
            .frame(width: 44, height: 44)
            .disabled(!canMoveToNextMonth())
            .buttonStyle(BasicButtonStyleUtil())
        }
    }
  
    // MARK: - 날짜 그리드 뷰

    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: date)
        let firstWeekday: Int = firstWeekdayOfMonth(in: date) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
    
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
            
                        SpendingCalendarCellView(spendingHistoryViewModel: spendingHistoryViewModel, date: date, day: day, clicked: clicked, isToday: isToday)
                        
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        SpendingCalendarCellView(spendingHistoryViewModel: spendingHistoryViewModel, date: date, day: day, isCurrentMonthDay: false)
                    }
                }
                .onTapGesture {
                    let currentDate = Calendar.current.startOfDay(for: Date()) // 날짜만 가져오기
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        let dateOnly = Calendar.current.startOfDay(for: date)
                        // 현재 날짜 이후인 경우 동작하지 않도록 함
                        if dateOnly <= currentDate {
                            clickedCurrentMonthDates = date
                            isClickDay(Date.day(from: date))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                clickDate = date
                                spendingHistoryViewModel.selectedDate = date
                                
                                self.showSpendingDetailView = true
                            }
                        }
                    }
                }
                .onChange(of: spendingHistoryViewModel.selectedDate) { newValue in
                    Log.debug("Selected date updated: \(String(describing: newValue))")
                }
            }
        }
    }
}

// MARK: - CalendarView Static 프로퍼티

private extension SpendingCalenderView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
  
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월"
        return formatter
    }()
  
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
}

// MARK: - 내부 로직 메서드

private extension SpendingCalenderView {
    /// 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: date),
                month: calendar.component(.month, from: date),
                day: 1
            )
        ) else {
            return Date()
        }
    
        var dateComponents = DateComponents()
        dateComponents.day = index
    
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
    
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }

    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
  
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
    
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
  
    /// 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    
        return previousMonth
    }
  
    /// 월 변경
    func changeMonth(by value: Int) {
        spendingHistoryViewModel.selectedDate = nil
        spendingHistoryViewModel.selectedDateId = 0
        
        spendingHistoryViewModel.currentDate = adjustedMonth(by: value)
        spendingHistoryViewModel.checkSpendingHistoryApi { success in
            if success {
                date = adjustedMonth(by: value)
            } else {
                Log.fault("지출내역 조회 Api 연동 실패")
            }
        }
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
    func canMoveToNextMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: 0, to: currentDate) ?? currentDate
    
        if adjustedMonth(by: 1) > targetDate {
            return false
        }
        return true
    }
  
    /// 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: date) {
            return newMonth
        }
        return date
    }
    
    func isClickDay(_ day: Int) {
        let data = spendingHistoryViewModel.dailySpendings.first(where: { $0.day == day })?.individuals[0]

        Log.debug(data?.id)
        Log.debug(data)

        spendingHistoryViewModel.selectedDateId = data?.id ?? 0
    }
}
