
import SwiftUI

struct CodeInputField: View {
    @Binding var code: String
    let onCodeChange: (String) -> Void
    let isTimerHidden: Bool
    let timerString: String
    let isDisabled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color("Gray01"))
                .frame(height: 46 * DynamicSizeFactor.factor())
            HStack {
                TextField("", text: $code)
                    .padding(.leading, 13 * DynamicSizeFactor.factor())
                    .font(.H4MediumFont())
                    .keyboardType(.numberPad)
                    .onChange(of: code, perform: onCodeChange)
                    .disabled(isDisabled)
                Spacer()
                if !isTimerHidden {
                    Text(timerString)
                        .padding(.trailing, 13 * DynamicSizeFactor.factor())
                        .font(.B1RegularFont())
                        .platformTextColor(color: Color("Mint03"))
                }
            }
        }
    }
}
