
import SwiftUI

struct TotalTargetAmountContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("지난 사용 금액")
                    .font(.headline)
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.leading, 18)
                
                Spacer()
                
                Image("icon_arrow_front_small")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding(.top, 18)
            
            HStack(spacing: 24 * DynamicSizeFactor.factor()) {
                ForEach(1 ..< 7) { month in
                    VStack {
                        Text("\(Int.random(in: 50 ... 90))")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray04"))
                        Rectangle()
                            .frame(width: 16 * DynamicSizeFactor.factor(), height: CGFloat(Int.random(in: 50 ... 100)) * DynamicSizeFactor.factor())
                            .platformTextColor(color: Color("Gray03"))
                            .clipShape(RoundedCornerUtil(radius: 15, corners: [.topLeft, .topRight]))
                        Text("\(month)월")
                            .font(.B3MediumFont())
                            .platformTextColor(color: Color("Gray06"))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160 * DynamicSizeFactor.factor(), alignment: .center) // height 수정 필요
            
            ForEach(0 ..< 3) { i in
                HStack {
                    VStack(alignment: .leading) {
                        Text("2024년 \(5 - i)월")
                            .font(.subheadline)
                        Text("\(Int.random(in: 700_000 ... 900_000))원")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Text("\(Int.random(in: 100_000 ... 200_000))원 더 썼어요")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
        }
        .background(Color("White01"))
        .padding(.horizontal, 20)
        .cornerRadius(8)
        
        Spacer()
    }
}
