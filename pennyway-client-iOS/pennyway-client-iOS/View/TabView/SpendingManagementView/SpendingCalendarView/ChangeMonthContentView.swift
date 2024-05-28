
import SwiftUI

struct ChangeMonthContentView: View {
    @ObservedObject var viewModel: MySpendingListViewModel
    @Binding var isPresented: Bool
    @State private var selectedMonth: Date = Date()
    private let calendars = Calendar.current
    private let months: [Date]

    init(viewModel: MySpendingListViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _isPresented = isPresented
        months = {
            let startDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1)) ?? Date()
            let endDate = Date()
            let calendar = Calendar.current
            var dates = [Date]()
            var date = startDate

            while date <= endDate {
                dates.append(date)
                date = calendar.date(byAdding: .month, value: 1, to: date) ?? date
            }

            return dates.reversed() // 최신 날짜가 상단에 오도록 배열을 역순으로 정렬
        }()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    Text("월 변경하기")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer()

                    Button(action: {
                        viewModel.ishidden = true
                        isPresented = false

                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .frame(width: 28, height: 28)
                    })
                }
                .padding(.horizontal, 20)

                ScrollView {
                    ForEach(months, id: \.self) { month in
                        HStack {
                            Text(monthTitle(from: month))
                                .font(.system(size: 18, weight: calendars.isDate(selectedMonth, equalTo: month, toGranularity: .month) ? .bold : .regular))
                                .foregroundColor(calendars.isDate(selectedMonth, equalTo: month, toGranularity: .month) ? Color("Mint01") : Color("Gray06"))
                                .padding(.vertical, 8)

                            Spacer()

                            if calendars.isDate(selectedMonth, equalTo: month, toGranularity: .month) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("Mint01"))
                            }
                        }
                        .padding(.horizontal)
                        .background(calendars.isDate(selectedMonth, equalTo: month, toGranularity: .month) ? Color("Mint03") : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedMonth = month
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ChangeMonthContentView(viewModel: MySpendingListViewModel(), isPresented: .constant(true))
}
