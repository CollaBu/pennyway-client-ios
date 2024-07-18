
import SwiftUI

struct ErrorText: View {
    let message: String
    let color: Color

    var body: some View {
        Text(message)
            .padding(.horizontal, 20)
            .font(.B1MediumFont())
            .platformTextColor(color: color)
    }
}
