import SwiftUI

// MARK: - TotalTargetAmountView

struct TotalTargetAmountView: View {
    @StateObject var viewModel = TotalTargetAmountViewModel()
    @State var isClickMenu = false
    @State private var selectedMenu: String? = nil // 선택한 메뉴
    @State var listArray: [String] = ["목표금액 수정", "초기화하기"]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    TotalTargetAmountHeaderView(viewModel: viewModel)

                    TotalTargetAmountContentView(viewModel: viewModel)

                    Spacer().frame(height: 29 * DynamicSizeFactor.factor())
                }
                .overlay(
                    VStack(alignment: .leading) {
                        if isClickMenu {
                            CustomDropdownMenuView(
                                isClickMenu: $isClickMenu,
                                selectedMenu: $selectedMenu,
                                listArray: listArray,
                                onItemSelected: { item in
                                    Log.debug("Selected item: \(item)")
                                }
                            ).padding(.trailing, 20)
                        }
                    }, alignment: .topTrailing
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Gray01"))
        .navigationBarColor(UIColor(named: "Mint03"), title: "")
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        NavigationUtil.popToRootView()
                    }, label: {
                        Image("icon_arrow_back_white")
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
                        isClickMenu = true
                        selectedMenu = nil
                    }, label: {
                        Image("icon_navigationbar_kebabmenu_white")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .padding(.trailing, 5)
                    .frame(width: 44, height: 44)
                }
                .offset(x: 10)
            }
        }
        .onAppear {
            viewModel.getTotalTargetAmountApi { _ in 
            }
        }
    }
}

#Preview {
    TotalTargetAmountView()
}
