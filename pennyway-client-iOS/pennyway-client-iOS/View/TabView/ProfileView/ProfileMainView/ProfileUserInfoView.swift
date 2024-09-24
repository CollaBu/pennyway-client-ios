import Combine
import SwiftUI

// MARK: - ProfileUserInfoView

struct ProfileUserInfoView: View {
    @Binding var showPopUpView: Bool
    @Binding var navigateToEditUsername: Bool
    @Binding var selectedUIImage: UIImage?
    @Binding var imageUrl: String

    @State private var name = ""
    @State private var refreshView = false
    
    @ObservedObject var viewModel: ProfileImageViewModel    
    @ObservedObject var viewModelWrapper: UserProfileViewModelWrapper

    private func loadUserData() {
        if let userData = getUserData() {
            name = userData.name // 사용자 이름
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 22 * DynamicSizeFactor.factor())
                
                Button(action: {
                    showPopUpView = true
                }, label: {
                    ZStack {
                        if let selectedImage = selectedUIImage {
                            // selectedUIImage가 nil이 아닌 경우
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)
                                .clipShape(Circle())
                        } else if let loadedImage = viewModel.imageUrl {
                            // userDefaults에 저장된 이미지가 nil이 아니고 빈 값이 아닌 경우
                            Image(uiImage: loadedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)
                                .clipShape(Circle())
                            
                        } else {
                            // selectedUIImage도 nil이고 userDefaults에 저장된 이미지도 nil이거나 빈 값인 경우
                            Image("icon_illust_no_image_no_margin")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)
                            
                            Image("icon_profile_camera")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 44 * DynamicSizeFactor.factor(), height: 44 * DynamicSizeFactor.factor())
                                .offset(x: 32 * DynamicSizeFactor.factor(), y: 21 * DynamicSizeFactor.factor())
                                .zIndex(2)
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
            .frame(maxWidth: .infinity, maxHeight: 267 * DynamicSizeFactor.factor())
            .background(Color("White01"))
            .onAppear {
                loadUserData()
                
                Log.debug("[ProfileUserInfoView]: \(viewModelWrapper.viewModel.userData.value.profileImage)")
                Log.debug("selectedUIImage: \(selectedUIImage)")
            }
            .onChange(of: viewModelWrapper.viewModel.userData.value.profileImage) { result in
                Log.debug("[ProfileUserInfoView] - onChange실행중")
                if result == nil {
                    selectedUIImage = nil
                } else {
                    if let updatedImage = viewModelWrapper.viewModel.userData.value.profileImage {
                        selectedUIImage = updatedImage
                    }
                }
            }
        }
    }
}
