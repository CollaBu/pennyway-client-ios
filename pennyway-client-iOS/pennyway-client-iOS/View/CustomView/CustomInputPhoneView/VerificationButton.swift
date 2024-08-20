
import SwiftUI

struct VerificationButton: View {
    let isEnabled: Bool
    let action: () -> Void
    @State private var buttonTitle: String = "인증번호 받기" // 초기 버튼 타이틀

    var body: some View {
        Button(action: {
            action()
            buttonTitle = "재전송하기" // 버튼 클릭 후 타이틀 변경
        }, label: {
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
