import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var action: (() -> Void)? // 수정

    var body: some View {
        Button(action: {
            action?()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image("icon_arrow_back")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
                .padding(5)
        })
    }
}
