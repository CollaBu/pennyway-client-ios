import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
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

    let profileViewHeight = 267 * DynamicSizeFactor.factor()
    @State private var initialOffset: CGFloat = 0 // 초기 오프셋 값 저장
    @State private var adjustedOffset: CGFloat = 0 // (현재 오프셋 값 - 초기 오프셋 값) 계산
    @State private var updateCount = 0 // 업데이트 횟수를 추적하는 변수

    @ObservedObject var viewModelWrapper: UserProfileViewModelWrapper

    var body: some View {
        NavigationAvailable {
            ZStack {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .setTabBarVisibility(isHidden: showPopUpView)
                    .navigationBarColor(UIColor(named: "White01"), title: viewModelWrapper.userData.username)
                    .background(Color("Gray01"))
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
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
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        // 사진 클릭한 경우
                        showPopUpView = false

                        if let selectedUIImage {
                            viewModelWrapper.viewModel.uploadPresignedUrl(selectedUIImage)
                            viewModelWrapper.viewModel.getUser()
                        }

                    }) {
                        ImagePicker(image: $selectedUIImage, isActive: $showImagePicker, sourceType: sourceType)
                            .edgesIgnoringSafeArea(.bottom)
                    }

                    .background(
                        NavigationLink(destination: EditUsernameView(), isActive: $navigateToEditUsername) {
                            EmptyView()
                        }.hidden()
                    )
                    .background(
                        NavigationLink(destination: ProfileMenuBarListView(), isActive: $isSelectedToolBar) {
                            EmptyView()
                        }.hidden()
                    )

                if showPopUpView {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    EditProfilePopUpView(
                        isPresented: $showPopUpView,
                        showPopUpView: $showPopUpView,
                        isHiddenTabBar: $isHiddenTabBar,
                        showImagePicker: $showImagePicker,
                        selectedUIImage: $selectedUIImage,
                        sourceType: $sourceType,
                        presignedUrlViewModel: presignedUrlViewModel,
                        viewModelWrapper: viewModelWrapper
                    )
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .id(showPopUpView)
        }
        .onAppear {
            Log.debug("isHiddenTabBar:\(isHiddenTabBar)")
            Log.debug("showPopUpView:\(showPopUpView)")
            viewModelWrapper.viewModel.getUser()
            loadUserData() // 사용자 정보(사진, 이름) 불러오기
        }
        .onChange(of: showPopUpView) { newValue in
            isHiddenTabBar = newValue
        }
        .onChange(of: ProfileNavigationState(navigateToEditUsername: navigateToEditUsername, isSelectedToolBar: isSelectedToolBar, showPopUpView: showPopUpView)) { state in
            if state.isReturn() {
                AnalyticsManager.shared.trackEvent(ProfileEvents.profileTapView, additionalParams: nil)
            }
        }
        .analyzeEvent(ProfileEvents.profileTapView)
    }

    // MARK: - Subviews

    private var content: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                ProfileUserInfoView(
                    showPopUpView: $showPopUpView,
                    navigateToEditUsername: $navigateToEditUsername,
                    selectedUIImage: $selectedUIImage,
                    viewModel: profileImageViewModel,
                    deleteViewModel: deleteProfileImageViewModel,
                    viewModelWrapper: viewModelWrapper
                )
                .background(Color("White01"))
                .offset(y: adjustedOffset > 0 ? -adjustedOffset : 0)

                VStack(alignment: .center) {
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
                .frame(maxWidth: .infinity)
                .background(Color("Gray01"))
                .offset(y: adjustedOffset > 0 ? (profileViewHeight - adjustedOffset) : profileViewHeight)
            }
            .frame(height: ScreenUtil.calculateAvailableHeight())
        }
    }

    private func loadUserData() {
        viewModelWrapper.viewModel.loadProfileImage { result in
            switch result {
            case let .success(loadedImage):
                // 이미지를 성공적으로 로드한 경우
                viewModelWrapper.viewModel.userData.value.imageUpdate(image: loadedImage)
                Log.debug("[ProfileView]-image: \(viewModelWrapper.userData.imageUrl)")
            case let .failure(error):
                // 이미지를 로드하는 데 실패한 경우
                Log.debug("[ProfileView]-이미지 로드에 실패: \(error)")
            }
        }
    }

    func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            if updateCount < 4 {
                updateCount += 1
            } else if initialOffset == 0 {
                initialOffset = offset
            }

            adjustedOffset = offset - initialOffset
        }
        return EmptyView()
    }
}

// MARK: - ProfileNavigationState

struct ProfileNavigationState: Equatable {
    let navigateToEditUsername: Bool
    let isSelectedToolBar: Bool
    let showPopUpView: Bool

    func isReturn() -> Bool {
        return !navigateToEditUsername && !isSelectedToolBar && !showPopUpView
    }
}

// MARK: - UserProfileViewModelWrapper

/// `DefaultUserProfileViewModel`의 `userData` 변화를 관찰하여 UI가 자동으로 업데이트되도록 하는 클래스
final class UserProfileViewModelWrapper: ObservableObject {
    @Published var userData: UserProfileItemModel
    var viewModel: any UserProfileViewModel

    init(viewModel: any UserProfileViewModel) {
        self.viewModel = viewModel
        userData = viewModel.userData.value

        // Observable을 통해 userData 변화를 감지하고 업데이트
        viewModel.userData.observe(on: self) { [weak self] newUserData in
            self?.userData = newUserData
        }
    }
}
