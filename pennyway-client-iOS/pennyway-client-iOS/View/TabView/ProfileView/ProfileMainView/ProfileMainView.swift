import SwiftUI

// MARK: - ProfileMainView

struct ProfileMainView: View {
    @State private var isSelectedToolBar = false
    @State private var navigateToEditUsername = false
    @State private var showPopUpView = false
    @State private var isHiddenTabBar = false
    @State private var selectedUIImage: UIImage? // image를 selectedUIImage로 대체
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @StateObject var deleteProfileImageViewModel = DeleteProfileImageViewModel()

    @StateObject var presignedUrlViewModel = PresignedUrlViewModel()
    @StateObject var profileImageViewModel = ProfileImageViewModel()

    @State var imageUrl = ""
    @State private var offsetY: CGFloat = CGFloat.zero

    let profileViewHeight = 260 * DynamicSizeFactor.factor()

    var body: some View {
        NavigationAvailable {
            ZStack {
                ScrollView {
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        setOffset(offset: offset)
                        ProfileUserInfoView(
                            showPopUpView: $showPopUpView,
                            navigateToEditUsername: $navigateToEditUsername,
                            selectedUIImage: $selectedUIImage,
                            imageUrl: $imageUrl,
                            viewModel: profileImageViewModel, deleteViewModel: deleteProfileImageViewModel
                        )
                        .background(Color("White01"))
                        .offset(y: offset > 0 ? -offset : 0)
                    }
                    .frame(height: profileViewHeight)
                    .border(.black)
                    
                    VStack {
                        Spacer().frame(height: 33 * DynamicSizeFactor.factor())
                        
                        Text("내 게시글")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .offset(x: -140, y: 0)
                        
                        Spacer().frame(height: 6 * DynamicSizeFactor.factor())
                        
                        Image("icon_illust_empty")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100 * DynamicSizeFactor.factor(), height: 100 * DynamicSizeFactor.factor())
                        
                        Text("아직 작성된 글이 없어요")
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(1)
                    }
                    .padding(.horizontal, 20)
                    .background(Color("Gray01"))
                }
                
                if showPopUpView {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    EditProfilePopUpView(
                        isPresented: $showPopUpView,
                        showPopUpView: $showPopUpView,
                        isHiddenTabBar: $isHiddenTabBar,
                        showImagePicker: $showImagePicker,
                        selectedUIImage: $selectedUIImage,
                        sourceType: $sourceType,
                        imageUrl: $imageUrl,
                        presignedUrlViewModel: presignedUrlViewModel
                    )
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $showImagePicker, onDismiss: {
                // 사진 클릭한 경우
                showPopUpView = false
                presignedUrlViewModel.image = selectedUIImage
                presignedUrlViewModel.generatePresignedUrlApi { success in
                    if success {
                        presignedUrlViewModel.storePresignedUrlApi { success in
                            if success {
                                profileImageViewModel.uploadProfileImageApi(presignedUrlViewModel.payload)
                            }
                        }
                    }
                }
            }) {
                ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .id(showPopUpView)
            .setTabBarVisibility(isHidden: showPopUpView)
            .navigationBarColor(UIColor(named: "White01"), title: getUserData()?.username ?? "")
            .background(Color("Gray01"))
            //            .navigationBarTitle(getUserData()?.username ?? "", displayMode: .inline)
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
                        .buttonStyle(BasicButtonStyleUtil())
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
            loadUserDataImage() // 사용자 프로필 사진 불러오기
        }
        .onChange(of: showPopUpView) { newValue in
            isHiddenTabBar = newValue
        }
    }
    
    private func loadUserDataImage() {
        if let userData = getUserData() {
            imageUrl = userData.profileImageUrl
            profileImageViewModel.loadImageUrl(from: imageUrl)
        }
    }
    
    func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.offsetY = offset
            Log.debug("??:\(offset)")
        }
        return EmptyView()
    }
}

#Preview {
    ProfileMainView()
}
