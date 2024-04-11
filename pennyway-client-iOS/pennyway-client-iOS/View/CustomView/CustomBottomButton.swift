
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.ButtonH4SemiboldFont())
                .platformTextColor(color: isFormValid ? Color("White01") : Color("Gray04")).frame(maxWidth: .infinity)
                .padding(.horizontal, 23)
                .padding(.vertical, 19.55)
        }
        .frame(maxWidth: .infinity)
        .background(isFormValid ? Color("Mint03") : Color("Gray03"))

        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 23)
    }
}
