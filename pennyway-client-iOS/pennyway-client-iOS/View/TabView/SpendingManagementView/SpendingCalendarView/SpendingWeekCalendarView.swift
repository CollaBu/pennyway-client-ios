import SwiftUI

// MARK: - SpendingWeekCalendarView

struct SpendingWeekCalendarView: View {
    @State private var selectedDate = Date()
    private let calendar = Calendar.current
  
    var body: some View {
        VStack(alignment: .leading, spacing: 20 * DynamicSizeFactor.factor()) {
            monthView
      
            ZStack {
                dayView
            }
            .frame(height: 30)
            .padding(.horizontal, 10)
        }
    }
  
    // MARK: - 월 표시 뷰

    private var monthView: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(monthTitle(from: selectedDate))
                    .font(.ButtonH4SemiboldFont())
                
                Button(action: {}, label: {
                    Image("icon_arrow_back_small")
                })
                
                Spacer()
                
                HStack(spacing: 16 * DynamicSizeFactor.factor()) {
                    Button(
                        action: {
                            changeMonth(-1)
                        },
                        label: {
                            Image("icon_arrow_back_small")
                        }
                    )
                    
                    Button(
                        action: {
                            changeMonth(1)
                        },
                        label: {
                            Image("icon_arrow_front_small")
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
    
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                let components = (
                    0 ..< calendar.range(of: .day, in: .month, for: startDate)!.count)
                    .map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }
        
                ForEach(components, id: \.self) { date in
                    VStack(spacing: 10) {
                        Text(day(from: date))
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                        Text("\(calendar.component(.day, from: date))")
                            .font(.B2MediumFont())
                            .frame(width: 23 * DynamicSizeFactor.factor(), height: 26 * DynamicSizeFactor.factor())
                            .background(
                                Circle()
                                    .platformTextColor(color: calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color("Mint01") : Color.clear)
                            )
                            .platformTextColor(color: calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color("Mint03") : Color("Gray06"))
                            .padding(.horizontal, 7)
                    }
                    .cornerRadius(30)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .frame(height: 45 * DynamicSizeFactor.factor())
        }
    }
  
    // MARK: - 블러 뷰

//    private var blurView: some View {
//        HStack {
//            LinearGradient(
//                gradient: Gradient(
//                    colors: [
//                        Color.white.opacity(1),
//                        Color.white.opacity(0)
//                    ]
//                ),
//                startPoint: .leading,
//                endPoint: .trailing
//            )
//            .frame(width: 20)
//            .edgesIgnoringSafeArea(.leading)
//
//            Spacer()
//
//            LinearGradient(
//                gradient: Gradient(
//                    colors: [
//                        Color.white.opacity(1),
//                        Color.white.opacity(0)
//                    ]
//                ),
//                startPoint: .trailing,
//                endPoint: .leading
//            )
//            .frame(width: 20)
//            .edgesIgnoringSafeArea(.leading)
//        }
//    }
}

// MARK: - 로직

private extension SpendingWeekCalendarView {
    /// 월 표시
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter.string(from: date)
    }
  
    /// 월 변경
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(
            byAdding: .month,
            value: value,
            to: selectedDate
        ) else {
            return
        }
    
        selectedDate = date
    }
  
    /// 요일 추출
    func day(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }
}

// MARK: - SpendingWeekCalendarView_Previews

#Preview {
    SpendingWeekCalendarView()
}
