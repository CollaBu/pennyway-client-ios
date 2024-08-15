
import SwiftUI

struct VerificationButton: View {
    let isEnabled: Bool
    let action: () -> Void
    let buttonTitle: String

    var body: some View {
        Button(action: action, label: {
            Text(buttonTitle)
                .font(.B1MediumFont())
                .platformTextColor(color: isEnabled ? Color("White01") : Color("Gray04"))
        })
        .padding(.horizontal, 13)
        .frame(width: 95 * DynamicSizeFactor.factor(), height: 46 * DynamicSizeFactor.factor())
        .background(isEnabled ? Color("Gray05") : Color("Gray03"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .disabled(!isEnabled)
        .buttonStyle(BasicButtonStyleUtil())
    }
}
