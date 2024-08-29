
import SwiftUI

func NavigationAvailable<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if #available(iOS 16.0, *) {
        return AnyView(NavigationStack { content() })
    } else {
        return AnyView(NavigationView { content() }
            .navigationViewStyle(.stack))//navigation index 파악위해 stack 사용
    }
}
