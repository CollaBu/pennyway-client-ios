import SwiftUI

struct DetailSpendingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSelectedCategory: Bool = false
    @State var selectedItem: String? = nil
    @State var listArray: [String] = ["수정하기", "내역 삭제"]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer().frame(height: 26 * DynamicSizeFactor.factor())

                MoreDetailSpendingView()
            }
        }
        .padding(.bottom, 34 * DynamicSizeFactor.factor())
        .padding(.horizontal, 20)
        .setTabBarVisibility(isHidden: true)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarColor(UIColor(named: "White01"), title: "")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_arrow_back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .padding(5)
                    })
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())

                }.offset(x: -10)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        isSelectedCategory.toggle()
                        Log.debug("isSelectedCategory: \(isSelectedCategory)")
                    }, label: {
                        Image("icon_navigationbar_kebabmenu")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 5)
                    .frame(width: 44, height: 44)
                }
                .offset(x: 10)
            }
        }
        .overlay(
            VStack(alignment: .center) {
                Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                if isSelectedCategory {
                    ZStack {
                        Rectangle()
                            .cornerRadius(4)
                            .platformTextColor(color: Color("White01"))
                            .padding(.vertical, 8)
                            .shadow(color: .black.opacity(0.06), radius: 7, x: 0, y: 0)

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(listArray, id: \.self) { item in
                                Button(action: {
                                    self.selectedItem = item
                                }, label: {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .platformTextColor(color: .clear)
                                            .frame(width: 120, height: 22)
                                            .cornerRadius(3)

                                        Text(item)
                                            .font(.B2MediumFont())
                                            .multilineTextAlignment(.leading)
                                            .platformTextColor(color: selectedItem == item ? Color("Gray05") : Color("Gray04"))
                                            .padding(.leading, 3)
                                    }
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 9)
                                    .background(selectedItem == item ? Color("Gray02") : Color("White01"))

                                })

                                .buttonStyle(PlainButtonStyle())
                            }
                            .cornerRadius(3)
                        }
                        .padding(.vertical, 12 * DynamicSizeFactor.factor())
                        .zIndex(5)
                    }
                    .frame(width: 125 * DynamicSizeFactor.factor(), height: 47 * DynamicSizeFactor.factor())
                    .zIndex(5)
                    .offset(x: 175 * DynamicSizeFactor.factor(), y: 13 * DynamicSizeFactor.factor())
                }
            }, alignment: .topLeading)
    }
}

#Preview {
    DetailSpendingView()
}
