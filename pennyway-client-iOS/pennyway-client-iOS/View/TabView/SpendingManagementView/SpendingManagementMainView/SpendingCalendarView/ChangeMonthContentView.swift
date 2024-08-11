import SwiftUI

struct ChangeMonthContentView: View {
    @ObservedObject var viewModel: SpendingHistoryViewModel
    @Binding var isPresented: Bool
    @State private var selectedMonth: Date
    @State private var months: [Date]

    private let calendars = Calendar.current
//    private let months: [Date]

    init(viewModel: SpendingHistoryViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _isPresented = isPresented
        _selectedMonth = State(initialValue: viewModel.selectedDate ?? viewModel.currentDate)

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

            return dates.reversed()
        }()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Spacer().frame(height: 28 * DynamicSizeFactor.factor())
                HStack {
                    Text("월 변경하기")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Spacer()

                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                    })
                    .buttonStyle(BasicButtonStyleUtil())
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 32) // 동적 ui 제외

                ScrollView {
                    ForEach(months, id: \.self) { month in
                        HStack {
                            Button(action: {
                                selectedMonth = month
//                                viewModel.currentDate = month
                                //                                viewModel.selectedDate = nil
                                //                                viewModel.selectedDateId = 0

                                viewModel.checkSpendingHistoryApi { success in
                                    if success {
                                        Log.debug("해당날짜 소비내역 가져오기 성공")
                                    } else {
                                        Log.debug("해당날짜 소비내역 가져오기 실패")
                                    }
                                }
                            }, label: {
                                Text(monthTitle(from: month))
                                    .font(.H4MediumFont())
                                    .platformTextColor(color: calendars.isDate(selectedMonth, equalTo: month, toGranularity: .month) ? Color("Mint03") : Color("Gray05"))
                                    .padding(.vertical, 14)
                            })
                            .buttonStyle(PlainButtonStyle())
                            .buttonStyle(BasicButtonStyleUtil())

                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ChangeMonthContentView(viewModel: SpendingHistoryViewModel(), isPresented: .constant(true))
}
