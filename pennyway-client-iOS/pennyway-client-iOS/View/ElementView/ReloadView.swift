
import SwiftUI

struct ReloadView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 4 * DynamicSizeFactor.factor()) {
            Button(action: {
                action()
            }, label: {
                Image("icon_reload")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
            })

            Text("다시 시도해 주세요")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
        }
    }
}
