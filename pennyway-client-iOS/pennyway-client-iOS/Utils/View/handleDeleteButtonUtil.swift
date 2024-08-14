
import SwiftUI

struct handleDeleteButtonUtil: View {
    var isVisible: Bool
    var action: () -> Void

    var body: some View {
        if isVisible {
            Button(action: {
                action()
            }, label: {
                Image("icon_close_filled_primary")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16 * DynamicSizeFactor.factor(), height: 16 * DynamicSizeFactor.factor())
            })
            .padding(.vertical, 15 * DynamicSizeFactor.factor())
            .offset(x: 130 * DynamicSizeFactor.factor(), y: 1 * DynamicSizeFactor.factor())
            .buttonStyle(BasicButtonStyleUtil())
        }
    }
}
