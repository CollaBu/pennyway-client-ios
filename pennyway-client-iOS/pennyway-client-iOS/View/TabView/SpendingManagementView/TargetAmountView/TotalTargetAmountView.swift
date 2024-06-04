import SwiftUI

struct TotalTargetAmountView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TotalTargetAmountHeaderView()

                TotalTargetAmountContentView()

                Spacer().frame(height: 29 * DynamicSizeFactor.factor())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Gray01"))
        .navigationBarColor(UIColor(named: "Mint03"), title: "")
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        NavigationUtil.popToRootView()
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
                    Button(action: {}, label: {
                        Image("icon_navigationbar_kebabmenu")
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
    }
}

#Preview {
    TotalTargetAmountView()
}
