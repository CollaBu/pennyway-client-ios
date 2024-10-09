//
//  ChatSettingView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/9/24.
//

import SwiftUI

struct ChatSettingView: View {
    @State private var isPublic: Bool = false // 토글 상태를 관리하는 변수
    @State private var password: String = ""
    @State private var isNavigateToEditView: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                // 상단 여백 및 아이콘 이미지
                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                
                Image("icon_illust_maintain_goal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88 * DynamicSizeFactor.factor(), height: 88 * DynamicSizeFactor.factor())
                    .cornerRadius(12 * DynamicSizeFactor.factor())
                
                Spacer().frame(height: 17 * DynamicSizeFactor.factor())
                
                // 채팅방 커버 수정 버튼
                CustomRoundedBtn(title: "채팅방 커버 변경", fontColor: Color("Mint03"), backgroundColor: Color("Mint01")) {
                    // 버튼 액션
                }
                
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())
                
                // 채팅방 이름 입력
                ChatRoomNameSection
                
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())
                
                // 공개 범위 설정
                PublicScopeSection
                
                Spacer()
            }
        }
        .navigationBarColor(UIColor(named: "White01"), title: "채팅방 설정")
        .background(Color("White01"))
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackButton()
                    .padding(.leading, 5)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
    }

    /// 채팅방 이름 입력 섹션
    private var ChatRoomNameSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("채팅방 이름")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("Gray01"))
                    .frame(height: 46 * DynamicSizeFactor.factor())
                
                Button(action: {
                    isNavigateToEditView = true
                }) {
                    HStack {
                        Text("채팅방 이름")
                            .font(.H4MediumFont())
                            .platformTextColor(color: Color("Gray07"))
                            .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                        Spacer()
                        Image("icon_navigationbar_write_primary")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20 * DynamicSizeFactor.factor(), height: 20 * DynamicSizeFactor.factor())
                            .padding(.trailing, 13 * DynamicSizeFactor.factor())
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
    }

    /// 공개 범위 설정 섹션
    private var PublicScopeSection: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            Text("공개 범위")
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray04"))
            
            HStack {
                Text("채팅방 공개 설정")
                    .font(.ButtonH4SemiboldFont())
                    .platformTextColor(color: Color("Gray07"))
                
                Spacer()
                
                Toggle(isOn: $isPublic) {}
                    .toggleStyle(CustomToggleStyle(hasAppeared: $isPublic))
            }
            
            if !isPublic {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())
                    
                    TextField("", text: $password)
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.horizontal, 13 * DynamicSizeFactor.factor())
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ChatSettingView()
}
