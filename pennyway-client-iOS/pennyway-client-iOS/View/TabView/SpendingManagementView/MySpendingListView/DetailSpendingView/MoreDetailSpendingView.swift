import SwiftUI

struct MoreDetailSpendingView: View {
//    @Binding var spendingId: Int

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(spacing: 10 * DynamicSizeFactor.factor()) {
                    Image("icon_category_education_on")
                        .frame(width: 32 * DynamicSizeFactor.factor(), height: 32 * DynamicSizeFactor.factor())
                        .scaledToFill()

                    Text("교육")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B1SemiboldeFont())
                }
                Spacer().frame(height: 5 * DynamicSizeFactor.factor())
                
                Text("6,000원")
                    .padding(.vertical, 4)
                    .platformTextColor(color: Color("Gray07"))
                    .font(.H1BoldFont())
                    
                Spacer()

                HStack {
                    Text("날짜")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                    
                    Text("6월 4일")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B1MediumFont())
                }
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                HStack {
                    Text("소비처")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                    
                    Text("스터디용 메모장")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B1MediumFont())
                }
                Spacer().frame(height: 16 * DynamicSizeFactor.factor())
                
                HStack {
                    Text("메모")
                        .platformTextColor(color: Color("Gray04"))
                        .font(.B1MediumFont())
                    
                    Spacer()
                }
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .frame(width: 280 * DynamicSizeFactor.factor(), height: 72 * DynamicSizeFactor.factor())
                        .platformTextColor(color: Color("Gray01"))
                        .cornerRadius(4)
                    
                    Text("이번 스터디도 무사히\n끝날 수 있도록 해주세요")
                        .platformTextColor(color: Color("Gray07"))
                        .font(.B1MediumFont())
                        .padding(12 * DynamicSizeFactor.factor())
                }
            }
        }
    }
}

#Preview {
    MoreDetailSpendingView()
}
