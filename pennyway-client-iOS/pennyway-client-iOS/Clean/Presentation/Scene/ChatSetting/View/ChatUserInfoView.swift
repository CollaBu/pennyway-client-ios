//
//  ChatUserInfoView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/11/24.
//

import SwiftUI

struct ChatUserInfoView: View {
    var body: some View {
        ZStack {
            // Mint background
            Color("MintBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top section with image, name, and action buttons
                VStack(spacing: 16) {
                    Spacer().frame(height: 100) // Adds space from the top
                    
                    // Profile image (between mint and white background)
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                        
                        Image("profileImage") // Replace with actual image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }
                    .offset(y: 20) // Moves the profile image upwards
                    
                    // Username
                    Text("걱정하는 바다오리")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.black)
                    
                    Spacer().frame(height: 40) // Add space before buttons
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            // 방장 넘기기 action
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("방장 넘기기")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("MintButton"))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2))
                        }
                        
                        Button(action: {
                            // 내보내기 action
                        }) {
                            HStack {
                                Image(systemName: "hand.raised.fill")
                                Text("내보내기")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.red)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2))
                        }
                    }
                }
                .background(Color.white) // Bottom white background
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 50) // Adjust bottom padding
            }
        }
    }
}

// #Preview {
//    ProfileActionView()
// }
