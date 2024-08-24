
import SwiftUI

struct CustomToastView: View {
    var message: String
    var isNetworkError: Bool? = false

    var body: some View {
        VStack {
            HStack(spacing: 6 * DynamicSizeFactor.factor()) {
                Image((isNetworkError ?? false) ? "icon_caution" : "icon_checkone_on_small")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                Text(message)
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("White01"))
            }
            .padding(.horizontal, 12 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: 40 * DynamicSizeFactor.factor(), alignment: .leading)
        .background(Color("ToastGray")) // TODO: 색상 변경 필요
        .cornerRadius(6)
        .padding(.horizontal, 20)
    }
}

#Preview {
    CustomToastView(message: "")
}
