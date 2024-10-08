
import SwiftUI

// MARK: - ChatRoomContent

struct ChatRoomContent: View {
    let dummyChatRooms = [
        ChatRoom(id: 1, title: "배달음식 그만 먹는 방", description: "배달음식 NO 집밥 YES", background_image_url: "icon_close_filled_primary", password: "", privacy_setting: false, notify_setting: true),
        ChatRoom(id: 2, title: "월급 다 쓴 사람이 모인 방", description: "함께 저축해요", background_image_url: "icon_close_filled_primary", password: "1234", privacy_setting: true, notify_setting: true)
    ]
    var isMyChat: Bool // 내 채팅 여부

    var body: some View {
        ScrollView {
            VStack(spacing: 21 * DynamicSizeFactor.factor()) {
                ForEach(dummyChatRooms) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, isMyChat: isMyChat)
                }
            }
        }
    }
}

// MARK: - ChatRoomCell

struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let isMyChat: Bool

    var body: some View {
        HStack {
            Image(chatRoom.background_image_url)
                .resizable()
                .frame(width: 43 * DynamicSizeFactor.factor(), height: 43 * DynamicSizeFactor.factor())
                .cornerRadius(8)
                
            ZStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                        Text(chatRoom.title)
                            .font(.B1SemiboldeFont())
                            .platformTextColor(color: Color("Gray07"))
                            
                        if chatRoom.privacy_setting {
                            Image(systemName: "lock.fill")
                                .platformTextColor(color: Color("Gray04"))
                        }
                            
                        if isMyChat {
                            Spacer()
                                
                            VStack(alignment: .trailing) {
                                Text("어제")
                                    .font(.B3MediumFont())
                                    .platformTextColor(color: Color("Gray04"))
                            }
                        }
                    }
                        
                    Spacer().frame(height: 4 * DynamicSizeFactor.factor())
                        
                    Text(chatRoom.description)
                        .font(.B3MediumFont())
                        .platformTextColor(color: Color("Gray07"))
                        
                    Spacer().frame(height: 3 * DynamicSizeFactor.factor())
                        
                    Text("127명")
                        .font(.B3MediumFont())
                        .platformTextColor(color: Color("Gray04"))
                        .padding(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if isMyChat {
                    if chatRoom.notify_setting {
                        ZStack {
                            Text("24")
                                .font(.B3MediumFont())
                                .platformTextColor(color: Color("White01"))
                                .padding(.vertical, 3 * DynamicSizeFactor.factor())
                                .padding(.horizontal, 4 * DynamicSizeFactor.factor())
                                .background(Rectangle()
                                    .cornerRadius(12)
                                    .platformTextColor(color: Color("Mint03")))
                        }
                        .offset(x: 105 * DynamicSizeFactor.factor(), y: 10 * DynamicSizeFactor.factor())
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
    }
}
