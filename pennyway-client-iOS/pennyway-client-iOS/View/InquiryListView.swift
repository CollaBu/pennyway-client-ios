import SwiftUI

struct InquiryListView: View {
    var categoryMenu = ["이용 관련", "오류 신고", "서비스 제안", "기타"]
    @State private var selectedMenu: String = "카테고리"
    var body: some View {
        Menu(selectedMenu) {
            ForEach(categoryMenu, id:\.self) { categoryMenu in
                
                Button(action: {
                    selectedMenu = categoryMenu
                }, label: {
                    ZStack {
                        Text(categoryMenu)
                            .font(.B1SemiboldeFont())
                        
                    }
                })
            }
        }
        
    }
}

#Preview {
    InquiryListView()
}
