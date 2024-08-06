
import SwiftUI

struct ProfileMainView: View {
    @State private var isSelectedToolBar = false
    @State private var navigateToEditUsername = false
    @State var showPopUpView = false
    @State var isHiddenTabBar = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?

    var body: some View {
        NavigationAvailable {
            ZStack {
                ScrollView {
                    VStack {
                        ProfileUserInfoView(showPopUpView: $showPopUpView, navigateToEditUsername: $navigateToEditUsername, image: $image)

                        Spacer().frame(height: 33 * DynamicSizeFactor.factor())

                        VStack {
                            Text("내 게시글")
                                .font(.B1MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                                .offset(x: -140, y: 0)

                            Spacer().frame(height: 6 * DynamicSizeFactor.factor())

                            Image("icon_illust__empty")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100 * DynamicSizeFactor.factor(), height: 100 * DynamicSizeFactor.factor())

                            Text("아직 작성된 글이 없어요")
                                .font(.H4MediumFont())
                                .platformTextColor(color: Color("Gray07"))
                                .padding(1)
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer()
                }

                if showPopUpView == true {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    EditProfilePopUpView(isPresented: $showPopUpView, showPopUpView: $showPopUpView, isHiddenTabBar: $isHiddenTabBar, image: $image)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color("Gray01"))
            .setTabBarVisibility(isHidden: isHiddenTabBar)
            .navigationBarTitle(getUserData()?.username ?? "", displayMode: .inline)
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

            NavigationLink(destination: EditUsernameView(), isActive: $navigateToEditUsername) {
                EmptyView()
            }.hidden()

            NavigationLink(destination: ProfileMenuBarListView(), isActive: $isSelectedToolBar) {
                EmptyView()
            }.hidden()
        }
        .onAppear {
            Log.debug("isHiddenTabBar:\(isHiddenTabBar)")
            Log.debug("showPopUpView:\(showPopUpView)")
        }
    }
}

#Preview {
    ProfileMainView()
}
