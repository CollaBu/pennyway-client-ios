

import SwiftUI

struct TermsAndConditionsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedText: Int? = 3
   
    var body: some View {
        ZStack{
            VStack(spacing: 14) {
                Spacer().frame(height: 10)
                
                NavigationCountView(selectedText: $selectedText)
                    .onAppear {
                        selectedText = 3
                    }
                
                TermsAndConditionsContentView()
                
                Spacer()
                
                Button(action: {
                    selectedText = 4
                }, label: {
                    Text("계속하기")
                        .font(.pretendard(.semibold, size: 14))
                        .platformTextColor(color: Color("Gray04"))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 17)
                })
                .frame(maxWidth: .infinity)
                .background(Color("Gray02"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.horizontal, 20)
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                
                NavigationLink(destination: WelcomeView(), tag: 4, selection: $selectedText) {
                    EmptyView()
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    NavigationBackButton()
                        .padding(.leading, 5)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    
                }.offset(x: -10)
            }
        }
    }
}

#Preview {
    TermsAndConditionsView()
}
