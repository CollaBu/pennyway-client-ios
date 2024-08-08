import SwiftUI

struct ProfileUserInfoView: View {
    @Binding var showPopUpView: Bool
    @Binding var navigateToEditUsername: Bool
    @Binding var image: Image?

    @State private var name = ""
    @State private var username = ""

    private func loadUserData() {
        if let userData = getUserData() {
            name = userData.name // 사용자 이름
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 27 * DynamicSizeFactor.factor())
                
                Button(action: {
                    showPopUpView = true
                }, label: {
                    ZStack {
                        if let image = image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 81 * DynamicSizeFactor.factor(), height: 81 * DynamicSizeFactor.factor(), alignment: .leading)
                                .clipShape(Circle())
                        } else {
                            Image("icon_illust_no image_no margin")
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
            .frame(maxWidth: .infinity, maxHeight: 304 * DynamicSizeFactor.factor())
            .background(Color("White01"))
            .onAppear {
                loadUserData()
            }
        }
    }
}
