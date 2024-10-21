
import SwiftUI

// MARK: - RoomTitleInput

struct RoomTitleInput: View {
    @Binding var roomTitle: String
    var title: String

    let baseAttribute: BaseAttribute
    let stringAttribute: StringAttribute

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            title.toAttributesText(base: baseAttribute, stringAttribute)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.horizontal, 20)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("Gray01"))
                    .frame(height: 46 * DynamicSizeFactor.factor())

                if roomTitle.isEmpty {
                    Text("채팅방 이름을 입력해주세요")
                        .platformTextColor(color: Color("Gray03"))
                        .padding(.leading, 13 * DynamicSizeFactor.factor())
                        .font(.H4MediumFont())
                }

                TextField("", text: $roomTitle)
                    .font(.H4MediumFont())
                    .platformTextColor(color: Color("Gray07"))
                    .padding(.horizontal, 13 * DynamicSizeFactor.factor())
            }
            .padding(.horizontal, 20)
        }
    }
}
