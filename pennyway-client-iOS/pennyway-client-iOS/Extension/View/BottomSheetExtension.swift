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
                            RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight])
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
    let minHeight: CGFloat
    let maxHeight: CGFloat

    @State private var currentHeight: CGFloat
    @State private var draggedOffset: CGFloat = 0

    init(isPresented: Binding<Bool>, minHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder sheetContent: @escaping () -> SheetContent) {
        _isPresented = isPresented
        self.sheetContent = sheetContent()
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        _currentHeight = State(initialValue: minHeight)
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
                        .frame(height: currentHeight + draggedOffset)
                        .background(
                            RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight])
                                .fill(Color("White01"))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translation = value.translation.height
                                    draggedOffset = -translation
                                }
                                .onEnded { value in
                                    let translation = value.translation.height
                                    let velocity = value.predictedEndLocation.y - value.location.y

                                    // withAnimation(.spring()) {
                                    if translation < currentHeight * 0.25 || velocity < -300 {
                                        currentHeight = maxHeight
                                    } else if translation > currentHeight * 0.25 || velocity > 300 {
                                        if currentHeight == minHeight {
                                            isPresented = false
                                        } else {
                                            currentHeight = minHeight
                                        }
                                    }
                                    draggedOffset = 0
                                    // }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: draggedOffset)
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

    func dragBottomSheet<SheetContent: View>(isPresented: Binding<Bool>, minHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder sheetContent: @escaping () -> SheetContent) -> some View {
        modifier(DragBottomSheet(isPresented: isPresented, minHeight: minHeight, maxHeight: maxHeight, sheetContent: sheetContent))
    }
}
