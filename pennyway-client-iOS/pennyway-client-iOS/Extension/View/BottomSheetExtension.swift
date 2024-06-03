
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

// MARK: - DragBottomSheet

struct DragBottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: SheetContent

    @State private var offset: CGFloat = 0
    @State private var lastDragValue: DragGesture.Value?

    init(isPresented: Binding<Bool>, @ViewBuilder sheetContent: () -> SheetContent) {
        _isPresented = isPresented
        self.sheetContent = sheetContent()
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }

                VStack {
                    Spacer()
                    sheetContent
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .offset(y: max(0, offset))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translation = value.translation.height
                                    self.offset = max(0, translation + (self.lastDragValue?.translation.height ?? 0))
                                    self.lastDragValue = value
                                }
                                .onEnded { _ in
                                    if self.offset > 400 { // 수정 필요
                                        self.offset = 0
                                        self.lastDragValue = nil
                                        self.isPresented = false
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: offset)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        modifier(BottomSheet(isPresented: isPresented, maxHeight: maxHeight, sheetContent: content))
    }

    func dragBottomSheet<SheetContent: View>(isPresented: Binding<Bool>, @ViewBuilder sheetContent: @escaping () -> SheetContent) -> some View {
        modifier(DragBottomSheet(isPresented: isPresented, sheetContent: sheetContent))
    }
}
