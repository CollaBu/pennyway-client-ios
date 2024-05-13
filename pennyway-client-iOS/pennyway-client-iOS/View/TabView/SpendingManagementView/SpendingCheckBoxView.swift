
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
            Text("반가워요 붕어빵님!\n이번 달에 총 ")
                .font(.H1BoldFont())
                .platformTextColor(color: Color("Gray07"))
//                + Text("\(totalSpent)원")
//                .font(.H3SemiboldFont())
//                // .platformTextColor(color: Color("Mint03"))
//                + Text(" 썼어요")
//                .font(.H3SemiboldFont())

            // 프로그래스 바
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 244 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Gray01"))
                
                Rectangle()
                    .frame(width: min(progressValue / 100 * 300, 300), height: 24 * DynamicSizeFactor.factor()) // 현재 지출에 따른 프로그래스 바
                    .platformTextColor(color: Color("Mint03"))
            }
            .cornerRadius(10)
            .padding(.top, 10)
            
            HStack {
                Text("0")
                    .foregroundColor(.black)
                    .padding(.leading, 5)
                Spacer()
                Text("100000")
                    .foregroundColor(.black)
                    .padding(.trailing, 5)
            }
        }
        .padding()
    }
}
