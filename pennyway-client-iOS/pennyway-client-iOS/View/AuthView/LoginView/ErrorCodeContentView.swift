import SwiftUI

struct ErrorCodeContentView: View {
    @State private var isCloseErrorPopUpView: Bool = true
    var body: some View {
        ZStack(alignment: .leading) {
            if isCloseErrorPopUpView {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 28 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Red01"))
                    .cornerRadius(17)
                
                Button(action: {
                    isCloseErrorPopUpView = false
                }, label: {
                    Image("icon_close_filled_red")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("Red03"))
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                })
                
                Text("아이디 또는 비밀번호가 잘못 입력되었어요")
                    .platformTextColor(color: Color("Red03"))
                    .font(.B1MediumFont())
                    .padding(.leading, 34 * DynamicSizeFactor.factor())
            }
        }
        .padding(.horizontal, 20 * DynamicSizeFactor.factor())
    }
}

#Preview {
    ErrorCodeContentView()
}
