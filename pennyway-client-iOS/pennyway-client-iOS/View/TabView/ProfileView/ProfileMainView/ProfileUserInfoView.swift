
import SwiftUI

struct ProfileUserInfoView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 19 * DynamicSizeFactor.factor())

            HStack(spacing: 19) {
                ZStack {
                    Image("icon_illust_error")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor(), alignment: .leading)

                    Image("icon_close_filled_primary")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        .offset(x: 20 * DynamicSizeFactor.factor(), y: 20 * DynamicSizeFactor.factor())
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("이름")
                            .font(.H3SemiboldFont())
                            .platformTextColor(color: Color("Mint03"))
                        Button(action: {}, label: {
                            Image("icon_arrow_front")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 21, height: 21, alignment: .leading)
                        })
                    }

                    Text("아이디님 반가워요!")
                        .font(.H4MediumFont())
                        .platformTextColor(color: Color("Gray05"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer().frame(height: 23 * DynamicSizeFactor.factor())

            HStack {
                Text("팔로워")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray05"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Image("icon_line_gray")
                    .frame(width: 1.2, height: 18 * DynamicSizeFactor.factor())
                    .background(Color("Gray03"))

                Text("팔로잉")
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray05"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 50 * DynamicSizeFactor.factor())
            .background(Color("Gray02"))
            .clipShape(RoundedRectangle(cornerRadius: 7))

            Spacer().frame(height: 29 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: 180 * DynamicSizeFactor.factor())
        .padding(.horizontal, 20)
        .background(Color("White01"))
    }
}
