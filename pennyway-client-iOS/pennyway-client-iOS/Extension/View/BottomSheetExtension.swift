
import SwiftUI

// MARK: - BottomSheet

struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let maxHeight: CGFloat
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    self.sheetContent()
                        .frame(maxWidth: .infinity)
                        .frame(height: maxHeight)
                        .background(
                            RoundedCornerUtil(radius: 20, corners: [.topLeft, .topRight])
                                .fill(Color("White01"))
                        )
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isPresented = false
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        modifier(BottomSheet(isPresented: isPresented, maxHeight: maxHeight, sheetContent: content))
    }
}
