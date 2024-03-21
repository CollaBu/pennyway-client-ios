//
//  NavigationCountView.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 3/22/24.
//

import SwiftUI

struct NavigationCountView: View {
    @Binding var selectedText: Int?
    
    var body: some View {
        HStack(spacing: 8) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                Text("1")
                    .padding(6)
                    .background(selectedText == 1 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText == 1 ? Color("White") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.pretendard(.medium, size: 12))
                    .onTapGesture {
                        selectedText = 1
                    }
                
                Text("2")
                    .padding(6)
                    .background(selectedText == 2 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText == 2 ? Color("White") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.pretendard(.medium, size: 12))
                    .onTapGesture {
                        selectedText = 2
                    }
                
                Text("3")
                    .padding(6)
                    .background(selectedText == 3 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText == 3 ? Color("White") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.pretendard(.medium, size: 12))
                    .onTapGesture {
                        selectedText = 3
                    }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}
