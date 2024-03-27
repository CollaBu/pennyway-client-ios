
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.pretendard(.semibold, size: 14))
                .platformTextColor(color: isFormValid ? Color("White") : Color("Gray04"))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 17)
        }
        .frame(maxWidth: .infinity)
        .background(isFormValid ? Color("Mint03") : Color("Gray03"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
    }
}
