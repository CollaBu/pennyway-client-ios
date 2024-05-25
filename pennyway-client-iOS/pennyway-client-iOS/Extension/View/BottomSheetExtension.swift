
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
                        .clipShape(RoundedCorners(tl: 15, tr: 15, bl: 0, br: 0)) // 위쪽의 모서리에만 cornerRadius 적용
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

// MARK: - RoundedCorners

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        let tr = min(min(self.tr, h / 2), w / 2)
        let tl = min(min(self.tl, h / 2), w / 2)
        let bl = min(min(self.bl, h / 2), w / 2)
        let br = min(min(self.br, h / 2), w / 2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle.degrees(-90), endAngle: Angle.degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle.degrees(0), endAngle: Angle.degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle.degrees(90), endAngle: Angle.degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle.degrees(180), endAngle: Angle.degrees(270), clockwise: false)

        return path
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        modifier(BottomSheet(isPresented: isPresented, maxHeight: maxHeight, sheetContent: content))
    }
}
