import SwiftUI

// MARK: - SelectSpendingDayView

struct SelectSpendingDayView: View {
    @ObservedObject var viewModel: AddSpendingHistoryViewModel

    @Binding var isPresented: Bool
    @Binding var clickDate: Date?

    @State private var selectedDate: Date

    init(viewModel: AddSpendingHistoryViewModel, isPresented: Binding<Bool>, clickDate: Binding<Date?>) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _isPresented = isPresented
        _clickDate = clickDate
        _selectedDate = State(initialValue: clickDate.wrappedValue ?? Date())
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("날짜")
                    .font(.H3SemiboldFont())
                    .padding(.leading, 20)
                    .padding(.top, 28)
                Spacer()
            }

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            DatePicker("", selection: $viewModel.selectedDate, in: dateRange, displayedComponents: [.date])

                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .environment(\.timeZone, TimeZone.autoupdatingCurrent)
                .frame(height: 114 * DynamicSizeFactor.factor())
                .clipped()

            Spacer()

            CustomBottomButton(action: {
                let today = Date()
                let timezone = TimeZone.autoupdatingCurrent
                let secondsFromGMT = timezone.secondsFromGMT(for: today)
                let localizedDate = viewModel.selectedDate.addingTimeInterval(TimeInterval(secondsFromGMT))
                clickDate = localizedDate
                isPresented = false
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .onAppear {
            Log.debug("viewModel.selectedDate: \(viewModel.selectedDate)")
            Log.debug("selectedDate:\(selectedDate)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }

    private var dateRange: ClosedRange<Date> { // 2000년도부터 현재까지로 제한
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        let endDate = Date()
        return startDate ... endDate
    }
}
