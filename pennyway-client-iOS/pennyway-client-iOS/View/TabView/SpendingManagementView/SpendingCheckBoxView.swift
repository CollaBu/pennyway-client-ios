
import SwiftUI

struct SpendingCheckBoxView: View {
    /// 총 지출량
    var totalSpent: Int = 40000
    
    /// 프로그래스 바에 사용될 최대 값
    let maxValue: CGFloat = 100_000
    
    /// 프로그래스 바의 현재 값 (0부터 maxValue까지)
    var progressValue: CGFloat {
        return CGFloat(totalSpent) / maxValue * 100
    }
    
    var body: some View {
        VStack {
            // 텍스트 뷰
            
            Spacer().frame(height: 18 * DynamicSizeFactor.factor())
            
            HStack {
                Text("반가워요 붕어빵님!\n이번 달에 총 ")
                    .font(.H3SemiboldFont())
                    // .platformTextColor(color: Color("Gray07"))
                    + Text("\(totalSpent)원")
                    .font(.H3SemiboldFont())
                    // .platformTextColor(color: Color("Mint03"))
                    + Text(" 썼어요")
                    .font(.H3SemiboldFont())
                Spacer()
            }
            .frame(height: 44 * DynamicSizeFactor.factor())
            .padding(.leading, 18 * DynamicSizeFactor.factor())

            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

            // 프로그래스 바
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 244 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Gray01"))
                    
                Rectangle()
                    .frame(width: min(progressValue / 100 * 300, 300), height: 24 * DynamicSizeFactor.factor()) // 현재 지출에 따른 프로그래스 바
                    .platformTextColor(color: Color("Mint03"))
            }
            .cornerRadius(15)
            .padding(.horizontal, 18 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 6 * DynamicSizeFactor.factor())
            
            HStack {
                Text("0")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Mint03"))
                    .padding(.leading, 4 * DynamicSizeFactor.factor())
                Spacer()
                
                HStack {
                    Text("100000")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.trailing, 4 * DynamicSizeFactor.factor())
                    
                    // 버튼 추가
                }
            }
            .frame(width: 244 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 16)
        }
        .frame(maxWidth: .infinity, maxHeight: 144 * DynamicSizeFactor.factor())
        .background(Color("White01"))
        .cornerRadius(8)
    }
}
