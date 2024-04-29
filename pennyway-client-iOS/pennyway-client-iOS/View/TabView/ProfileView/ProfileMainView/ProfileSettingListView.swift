import SwiftUI

struct ProfileSettingListView: View {
    var body: some View {
        VStack{
            
            Spacer().frame(height: 32 * DynamicSizeFactor.factor())
            
            LazyVStack(spacing: 0) {
                SectionView(title: "내 정보", items: ["내 정보 수정", "내가 쓴 글", "스크랩", "비밀번호 변경"])
                SectionView(title: "앱 설정", items: ["알림 설정"])
                SectionView(title: "이용안내", items: ["문의하기"])
                SectionView(title: "기타", items: ["로그아웃", "회원탈퇴"])
            }
        }
        .frame(maxWidth: .infinity, minHeight: 511)
        .background(Color("White01"))
    }
}

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.B2SemiboldFont())
                .platformTextColor(color: Color("Gray04"))
                .background(Color(UIColor.systemBackground))
            
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
            
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.vertical, 7)
            }
            Spacer().frame(height: 14 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 21)
    }
}

