//
//  ChatUserInfoView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/11/24.
//

import SwiftUI

// MARK: - ChatUserInfoView

struct ChatUserInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showTransferPopUp: Bool = false // 방장 넘기기 팝업 상태
    @State private var showKickOutPopUp: Bool = false // 내보내기 팝업 상태

    var body: some View {
        ZStack {
            UserInfoContent

            // 방장 넘기기 팝업
            if showTransferPopUp {
                CustomPopUpView(showingPopUp: $showTransferPopUp,
                                titleLabel: "방장 권한을 넘길까요?",
                                subTitleLabel: "권한을 넘기면 다시 취소할 수 없어요",
                                firstBtnAction: { self.showTransferPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showTransferPopUp = false
                                },
                                secondBtnLabel: "넘길래요",
                                secondBtnColor: Color(.mint03)
                )
            }

            // 내보내기 팝업
            if showKickOutPopUp {
                CustomPopUpView(showingPopUp: $showKickOutPopUp,
                                titleLabel: "내보내기",
                                subTitleLabel: "\(mockMembers[1].username)님을 내보낼까요?",
                                firstBtnAction: { self.showKickOutPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showKickOutPopUp = false
                                },
                                secondBtnLabel: "내보내기",
                                secondBtnColor: Color(.red03)
                )
            }
        }
        .setTabBarVisibility(isHidden: true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Color.red.opacity(0.1) // 변경 필요
        )
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("icon_close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(5)
                    })
                    .frame(width: 44, height: 44)
                    .buttonStyle(BasicButtonStyleUtil())
                }
            }
        }
    }

    private var UserInfoContent: some View {
        VStack {
            Spacer()

            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    Rectangle()
                        .platformTextColor(color: .clear)
                        .frame(width: 90 * DynamicSizeFactor.factor(), height: 90 * DynamicSizeFactor.factor())
                        .background(
                            Image("icon_illust_maintain_goal")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90 * DynamicSizeFactor.factor(), height: 90 * DynamicSizeFactor.factor())
                                .clipped()
                        )
                        .cornerRadius(17)
                        .overlay(
                            RoundedRectangle(cornerRadius: 17)
                                .inset(by: -1.5 * DynamicSizeFactor.factor())
                                .stroke(.white01, lineWidth: 3)
                        )

                    Text("걱정하는 바다오리")
                        .font(.H3SemiboldFont())
                        .platformTextColor(color: .gray07)
                }
                .offset(y: -35 * DynamicSizeFactor.factor())

                HStack(spacing: 14 * DynamicSizeFactor.factor()) {
                    ActionButton(title: "방장 넘기기", icon: "person.fill", textColor: .mint03, backgroundColor: .mint01, action: {
                        showTransferPopUp = true
                    })
                    ActionButton(title: "내보내기", icon: "hand.raised.fill", textColor: .red03, backgroundColor: .red01, action: {
                        showKickOutPopUp = true
                    })
                }

                Spacer().frame(height: 50 * DynamicSizeFactor.factor())
            }
            .frame(height: 180 * DynamicSizeFactor.factor())
            .frame(maxWidth: .infinity)
            .background(Color(.white01))
        }
    }

    // MARK: - ActionButton (Private)

    private struct ActionButton: View {
        let title: String
        let icon: String
        let textColor: Color
        let backgroundColor: Color
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack(spacing: 7) {
                    Image(systemName: icon)
                    Text(title)
                }
                .frame(width: 130 * DynamicSizeFactor.factor())
                .padding(.vertical, 14 * DynamicSizeFactor.factor())
                .background(backgroundColor)
                .platformTextColor(color: textColor)
                .cornerRadius(6)
            }
        }
    }
}

#Preview {
    ChatUserInfoView()
}
