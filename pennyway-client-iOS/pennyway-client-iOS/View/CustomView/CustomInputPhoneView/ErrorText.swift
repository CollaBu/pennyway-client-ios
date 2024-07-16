
import SwiftUI

struct ErrorText: View {
    let message: String

    var body: some View {
        Text(message)
            .padding(.horizontal, 20)
            .font(.B1MediumFont())
            .platformTextColor(color: Color("Red03"))
    }
}
