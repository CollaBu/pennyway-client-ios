
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool
    var isSelectedAgreeBtn: Binding<Bool>?

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.ButtonH4SemiboldFont())
                .platformTextColor(color: isButtonEnabled ? Color("White01") : Color("Gray04")).frame(maxWidth: .infinity)
                .padding(.vertical, 17 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity)
        .background(isButtonEnabled ? Color("Mint03") : Color("Gray03"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
    }

    private var isButtonEnabled: Bool {
        if let isSelectedAgreeBtn = isSelectedAgreeBtn?.wrappedValue {
            return isFormValid && isSelectedAgreeBtn
        } else {
            return isFormValid
        }
    }
}
