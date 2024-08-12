
import SwiftUI

struct VerificationButton: View {
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text("인증번호 받기")
                .font(.B1MediumFont())
                .platformTextColor(color: isEnabled ? Color("White01") : Color("Gray04"))
        })
        .padding(.horizontal, 13)
        .frame(height: 46 * DynamicSizeFactor.factor())
        .background(isEnabled ? Color("Gray05") : Color("Gray03"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .disabled(!isEnabled)
        .buttonStyle(BasicButtonStyleUtil())
    }
}
