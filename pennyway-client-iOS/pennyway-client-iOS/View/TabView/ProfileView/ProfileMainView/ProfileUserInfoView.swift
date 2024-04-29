
import SwiftUI

struct ProfileUserInfoView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 19 * DynamicSizeFactor.factor())

            HStack {
                Image("icon_close_filled_primary")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60 * DynamicSizeFactor.factor(), height: 60 * DynamicSizeFactor.factor(), alignment: .leading)
                VStack(alignment: .leading) {
                    Text("이름")
                        .platformTextColor(color: Color("Mint03"))
                    Text("아이디")
                        .platformTextColor(color: Color("Gray05"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

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
        .frame(maxWidth: .infinity, maxHeight: 180)
        .padding(.horizontal, 20)
        .background(Color("White01"))
    }
}
