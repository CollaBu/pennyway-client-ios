import SwiftUI

struct ErrorCodeContentView: View {
    @Binding var isCloseErrorPopUpView: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if isCloseErrorPopUpView {
                Rectangle()
                    .frame(height: 28 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Red01"))
                    .cornerRadius(17)

                Button(action: {
                    isCloseErrorPopUpView = false

                }, label: {
                    Image("icon_close_filled_red")
                        .aspectRatio(contentMode: .fill)
                        .platformTextColor(color: Color("Red03"))
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .padding(.leading, 9)
                })
                .buttonStyle(BasicButtonStyleUtil())

                Text("아이디 또는 비밀번호가 잘못 입력되었어요")
                    .platformTextColor(color: Color("Red03"))
                    .font(.B1MediumFont())
                    .padding(.leading, 34 * DynamicSizeFactor.factor())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20 * DynamicSizeFactor.factor())
    }
}

#Preview {
    ErrorCodeContentView(isCloseErrorPopUpView: .constant(true))
}
