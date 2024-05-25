import SwiftUI

struct SelectSpendingDayView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date

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

            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
            }

            Spacer()

            CustomBottomButton(action: {
                isPresented = false
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
