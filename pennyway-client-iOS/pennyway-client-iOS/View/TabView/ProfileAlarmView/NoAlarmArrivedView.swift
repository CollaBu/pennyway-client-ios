
import SwiftUI

struct NoAlarmArrivedView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 60 * DynamicSizeFactor.factor())

            Image("icon_illust_error")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100 * DynamicSizeFactor.factor(), height: 100 * DynamicSizeFactor.factor())

            Spacer().frame(height: 23 * DynamicSizeFactor.factor())

            Text("아직 도착한 알림이 없어요")
                .font(.H4MediumFont())
                .platformTextColor(color: Color("Gray04"))
                .padding(1)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NoAlarmArrivedView()
}
