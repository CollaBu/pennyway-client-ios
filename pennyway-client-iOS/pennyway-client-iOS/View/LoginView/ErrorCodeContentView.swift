import SwiftUI

struct ErrorCodeContentView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: 28 * DynamicSizeFactor.factor())
                .background(Color(red: 1, green: 0.95, blue: 0.95))
                .cornerRadius(17)

            Image("icon_close_filled_red")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("Red03"))
                .frame(width: 44 * DynamicSizeFactor.factor(), height: 44 * DynamicSizeFactor.factor())

            Text("아이디 또는 비밀번호가 잘못 입력되었어요")
                .platformTextColor(color: Color("Red03"))
                .font(.B1MediumFont())
                .padding(.leading, 38 * DynamicSizeFactor.factor())
        }
        .padding(.horizontal, 20 * DynamicSizeFactor.factor())
    }
}

#Preview {
    ErrorCodeContentView()
}
