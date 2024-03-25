

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
                
                CustomBottomButton(action: {
                    selectedText = 4
                }, label: "계속하기")
                .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                .border(Color.black)

                NavigationLink(destination: WelcomeView(), tag: 4, selection: $selectedText) {
                    EmptyView()
                }
                
            }
            .border(Color.black)
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
