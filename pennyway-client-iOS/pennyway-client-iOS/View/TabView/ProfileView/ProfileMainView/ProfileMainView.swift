
import SwiftUI

struct ProfileMainView: View {
    @State private var isSelectedToolBar = false
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?

    var body: some View {
        NavigationAvailable {
            ScrollView {
                VStack {
                    ProfileUserInfoView(image: $image, showImagePicker: $showImagePicker)

                    Spacer().frame(height: 33 * DynamicSizeFactor.factor())

                    VStack {
                        Text("내 게시글")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .offset(x: -140, y: 0)

                        Spacer().frame(height: 6 * DynamicSizeFactor.factor())

                        Image("icon_illust_error")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80 * DynamicSizeFactor.factor(), height: 80 * DynamicSizeFactor.factor(), alignment: .leading)
                            .padding(10)

                        Text("아직 작성된 글이 없어요")
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(1)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                loadImage()
            }) {
                ImagePicker(image: $selectedUIImage)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color("Gray01"))
            .setTabBarVisibility(isHidden: false)
            .navigationBarColor(UIColor(named: "White01"), title: getUserData()?.username)
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

    func loadImage() {
        guard let selectedImage = selectedUIImage else {
            return
        }
        image = Image(uiImage: selectedImage)
    }
}

#Preview {
    ProfileMainView()
}
