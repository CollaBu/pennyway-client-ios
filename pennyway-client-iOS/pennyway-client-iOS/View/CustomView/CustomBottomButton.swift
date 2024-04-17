
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool
    @Binding var isDuplicateUserName: Bool //아이디 중복 체크

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.ButtonH4SemiboldFont())
                .platformTextColor(color: isFormValid && !isDuplicateUserName ? Color("White01") : Color("Gray04")).frame(maxWidth: .infinity)
                .padding(.vertical, 17 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity)
        .background(isFormValid && !isDuplicateUserName ? Color("Mint03") : Color("Gray03"))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
    }
}
