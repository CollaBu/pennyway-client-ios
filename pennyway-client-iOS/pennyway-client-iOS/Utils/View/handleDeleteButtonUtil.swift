
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
            })
            .offset(x: 120 * DynamicSizeFactor.factor(), y: 1 * DynamicSizeFactor.factor())
        }
    }
}
