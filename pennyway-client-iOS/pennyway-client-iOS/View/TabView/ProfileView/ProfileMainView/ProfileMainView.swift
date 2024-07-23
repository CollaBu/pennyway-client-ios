
import SwiftUI

struct ProfileMainView: View {
    @State private var isSelectedToolBar = false
    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    ProfileUserInfoView()

                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                }
                .background(Color("Gray01"))
            }
            .setTabBarVisibility(isHidden: false)
            .navigationBarColor(UIColor(named: "White01"), title: "프로필")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isSelectedToolBar = true
                        }, label: {
                            Image("icon_hamburger_button")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .padding(5)
                        })
                        .frame(width: 44, height: 44)
                    }
                }
            }
            NavigationLink(destination: ProfileMenuBarListView(), isActive: $isSelectedToolBar) {
                EmptyView()
            }.hidden()
        }
    }
}

#Preview {
    ProfileMainView()
}
