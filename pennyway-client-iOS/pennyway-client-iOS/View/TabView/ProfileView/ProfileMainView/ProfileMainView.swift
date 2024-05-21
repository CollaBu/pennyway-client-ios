
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("프로필", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isSelectedToolBar = true
                        }, label: {
                            Image("icon_navigationbar_bell_dot")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)
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
