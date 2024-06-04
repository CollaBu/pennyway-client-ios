
import SwiftUI

struct TotalTargetAmountContentView: View {
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 0) {
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    
                    Text("남은 금액")
                        .font(.B1MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                }
                .padding(.leading, 14)
                .padding(.bottom, 12)
                
                Spacer()
                
                Text("500,000원")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.trailing, 16)
                    .padding(.bottom, 12)
            }
            .frame(width: 280 * DynamicSizeFactor.factor(), height: 38 * DynamicSizeFactor.factor())
            .background(
                RoundedCornerUtil(radius: 8, corners: [.bottomLeft, .bottomRight])
                    .fill(Color("White01"))
            )
            
            Spacer().frame(height: 13 * DynamicSizeFactor.factor())
            
            VStack {
                HStack {
                    Text("지난 사용 금액")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                        .padding(.leading, 18)
                    
                    Spacer()
                    
                    Image("icon_arrow_front_small")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .padding(.trailing, 10)
                }
                .padding(.top, 18)
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor()) // TODO: height 수정 필요
                
                TotalTargetAmountGraphView()
                
                Spacer().frame(height: 13 * DynamicSizeFactor.factor()) // TODO: height 수정 필요
                
                ForEach(0 ..< 3) { i in
                    VStack(alignment: .leading) {
                        Text("2024년 \(5 - i)월")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                        
                        Spacer().frame(height: 8 * DynamicSizeFactor.factor())

                        HStack {
                            Text("\(Int.random(in: 700_000 ... 900_000))원")
                                .font(.ButtonH4SemiboldFont())
                                .platformTextColor(color: Color("Gray07"))
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15) // TODO: 동적 width 적용
                                    .frame(maxWidth: 111 * DynamicSizeFactor.factor(), maxHeight: 24 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: Color("Red01"))
                                
                                Text("\(Int.random(in: 5000 ... 200_000))원 더 썼어요")
                                    .platformTextColor(color: Color("Red03"))
                                    .font(.B2SemiboldFont())
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .frame(height: 60 * DynamicSizeFactor.factor())
                
                Spacer().frame(height: 10 * DynamicSizeFactor.factor())
            }
            .background(Color("White01"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
}
