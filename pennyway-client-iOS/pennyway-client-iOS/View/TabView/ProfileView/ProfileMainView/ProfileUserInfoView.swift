
import SwiftUI

struct ProfileUserInfoView: View {
    @State private var name = ""
    @State private var username = ""

    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?

    @Binding var navigateToEditUsername: Bool

    private func loadUserData() {
        if let userData = getUserData() {
            name = userData.name // 사용자 이름
            username = userData.username // 사용자 아이디
        }
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 27 * DynamicSizeFactor.factor())

            Button(action: {
                showImagePicker.toggle()
            }, label: {
                ZStack {
                    if let image = image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)
                            .clipShape(Circle())
                    } else {
                        Image("icon_close_filled_primary")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)

                        Image("icon_profile_camera")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44 * DynamicSizeFactor.factor(), height: 44 * DynamicSizeFactor.factor())
                            .offset(x: 24 * DynamicSizeFactor.factor(), y: 24 * DynamicSizeFactor.factor())
                    }
                }
            })
            .buttonStyle(PlainButtonStyle())

            Spacer().frame(height: 10 * DynamicSizeFactor.factor())

            Text("\(name)")
                .font(.H3SemiboldFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(1)

            Spacer().frame(height: 9 * DynamicSizeFactor.factor())

            Button(action: {
                navigateToEditUsername = true
            }, label: {
                HStack(alignment: .center, spacing: 8 * DynamicSizeFactor.factor()) {
                    Text("이름 수정하기")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("White01"))
                }
                .padding(.horizontal, 9 * DynamicSizeFactor.factor())
                .padding(.vertical, 6 * DynamicSizeFactor.factor())
                .background(Color("Mint03"))
                .cornerRadius(5)
            })
            .buttonStyle(PlainButtonStyle())

            Spacer().frame(height: 34 * DynamicSizeFactor.factor())

            HStack {
                VStack {
                    Text("0")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Text("게시물")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.horizontal, 34)

                Image("icon_line_gray")
                    .frame(width: 1.2, height: 36 * DynamicSizeFactor.factor())
                    .background(Color("Gray03"))

                VStack {
                    Text("0")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Text("팔로워")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.horizontal, 34)

                Image("icon_line_gray")
                    .frame(width: 1.2, height: 36 * DynamicSizeFactor.factor())
                    .background(Color("Gray03"))

                VStack {
                    Text("0")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: Color("Gray07"))

                    Text("팔로잉")
                        .font(.B2MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.horizontal, 34)
            }

            Spacer().frame(height: 28 * DynamicSizeFactor.factor())
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            loadImage()
        }) {
            ImagePicker(image: $selectedUIImage)
                .edgesIgnoringSafeArea(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: 304 * DynamicSizeFactor.factor())
        .background(Color("White01"))
        .onAppear {
            loadUserData()
        }
    }

    func loadImage() {
        guard let selectedImage = selectedUIImage else {
            return
        }
        image = Image(uiImage: selectedImage)
    }
}
