
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(label)
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: isFormValid ? Color("White01") : Color("Gray04"))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 47 * DynamicSizeFactor.factor())
            .background(isFormValid ? Color("Mint03") : Color("Gray03"))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(.horizontal, 20)
        .buttonStyle(PlainButtonStyle())
        .buttonStyle(BasicButtonStyleUtil())
    }
}
