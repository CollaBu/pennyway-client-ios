
import SwiftUI

// MARK: - RoomTitleInput

struct RoomTitleInput: View {
    @Binding var roomTitle: String
    var title: String
//    var placeholder: String

    let baseAttribute: BaseAttribute
    let stringAttribute: StringAttribute

    var body: some View {
        VStack(alignment: .leading) {
            title.toAttributesText(base: baseAttribute, stringAttribute)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Gray07"))
                .padding(.horizontal, 20)

            CustomInputView(inputText: $roomTitle, placeholder: "채팅방 이름을 입력해주세요", isSecureText: false)
        }
    }
}
