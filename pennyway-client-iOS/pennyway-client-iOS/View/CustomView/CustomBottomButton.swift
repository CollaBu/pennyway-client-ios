
import SwiftUI

struct CustomBottomButton: View {
    let action: () -> Void
    let label: String
    @Binding var isFormValid: Bool
    var alwaysMint: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.pretendard(.semibold, size: 14))
                .platformTextColor(color: alwaysMint ? Color("White01") : (isFormValid ? Color("White01"): Color("Gray04"))) //수정
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 17)
        }
        .frame(maxWidth: .infinity)
        .background(alwaysMint ? Color("Mint03") : (isFormValid ? Color("Mint03") : Color("Gray03"))) //수정
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 20)
    }
}

