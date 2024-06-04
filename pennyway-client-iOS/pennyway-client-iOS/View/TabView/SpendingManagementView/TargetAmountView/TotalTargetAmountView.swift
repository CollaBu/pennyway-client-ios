import SwiftUI

struct TotalTargetAmountView: View {
    var body: some View {
        VStack(spacing: 16) {
            TotalTargetAmountHeaderView()
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label("현재 소비 금액", systemImage: "creditcard")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("0원")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("남은 금액", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("500,000원")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("지난 사용 금액")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 8) {
                    ForEach(1 ..< 7) { month in
                        VStack {
                            Text("\(Int.random(in: 50 ... 90))")
                                .font(.headline)
                            Rectangle()
                                .frame(width: 20, height: CGFloat(Int.random(in: 50 ... 90)))
                                .foregroundColor(.gray)
                            Text("\(month)월")
                                .font(.caption)
                        }
                    }
                }
                .padding(.top, 8)
                
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
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .background(Color("White01"))
    }
}

#Preview {
    TotalTargetAmountView()
}
