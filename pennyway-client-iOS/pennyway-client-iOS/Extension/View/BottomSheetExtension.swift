
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
                        .background(Color("White01"))
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
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

// MARK: - RoundedCorner

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        modifier(BottomSheet(isPresented: isPresented, maxHeight: maxHeight, sheetContent: content))
    }
}
