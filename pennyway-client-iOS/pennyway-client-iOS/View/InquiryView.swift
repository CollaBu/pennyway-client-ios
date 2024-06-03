
import SwiftUI

struct InquiryView: View {
    @StateObject var viewModel = InquiryViewModel()
    @State private var isSelectedCategory: Bool = false
    @State private var isSelectedAgreeBtn: Bool = false
    @State private var showAgreement: Bool = false

    let placeholder: String = "문의 내용을 입력해주세요"

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Spacer().frame(height: 31 * DynamicSizeFactor.factor())
                        
                ZStack(alignment: .leading) {
                    HStack {
                        InquiryListView(viewModel: viewModel)
                        
                        Spacer()
                        
                        Text("문의가 필요해요")
                            .platformTextColor(color: Color("Gray05"))
                            .font(.H4MediumFont())
//                            .padding(.leading, 15 * DynamicSizeFactor.factor())
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 44)
                .zIndex(10)
                        
                Spacer().frame(height: 18 * DynamicSizeFactor.factor())
                        
                CustomInputView(inputText: $viewModel.email, titleText: "이메일", placeholder: "이메일 입력", onCommit: {
                    viewModel.validateEmail()
                    viewModel.validateForm()
                }, isSecureText: false)
                            
                if viewModel.showErrorEmail {
                    Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                    errorMessage("유효하지 않는 이메일 형식이에요")
                        .offset(x: -72.5 * DynamicSizeFactor.factor())
                }
                                                    
                Spacer().frame(height: 24 * DynamicSizeFactor.factor())

                VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
                    Text("문의 내용")
                        .padding(.horizontal, 20)
                        .font(.B1RegularFont())
                        .platformTextColor(color: Color("Gray04"))
                            
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("Gray01"))
                                    .frame(height: 123 * DynamicSizeFactor.factor())
                                        
                                TextEditor(text: $viewModel.content)
                                    .font(.B1MediumFont())
                                    .padding(.horizontal, 10)
                                    .padding(.top, 8)
                                    .zIndex(0)
                                    .colorMultiply(Color("Gray01"))
                                    .cornerRadius(6)
                                    .TextAutocapitalization()
                                    .AutoCorrectionExtensions()
                                    .onChange(of: viewModel.content) { _ in
                                        if viewModel.content.count > 500 {
                                            viewModel.content = String(viewModel.content.prefix(500))
                                        }
                                                
                                        viewModel.validateForm()
                                    }
                                    .frame(height: 123)
                                        
                                if viewModel.content.isEmpty {
                                    Text(placeholder)
                                        .font(.B1MediumFont())
                                        .padding(.leading, 14)
                                        .padding(.top, 16)
                                        .platformTextColor(color: Color("Gray03"))
                                        .cornerRadius(6)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .padding(.horizontal, 20)
                    }
                                                        
                    HStack(spacing: 0) {
                        Button(action: {
                            viewModel.isSelectedAgreeBtn.toggle()
                            viewModel.validateForm()
                        }, label: {
                            let selected = viewModel.isSelectedAgreeBtn == true ? Image("icon_checkone_on_small") : Image("icon_checkone_off_small")
                                    
                            selected
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        })
                        .padding(.leading, 20 * DynamicSizeFactor.factor())
                                
                        Text("정보 제공에 동의할게요")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                            .padding(.leading, 7 * DynamicSizeFactor.factor())
                                
                        Spacer()
                                
                        Button(action: {
                            withAnimation {
                                showAgreement.toggle()
                            }
                        }, label: {
                            Image("icon_arrow_down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                .rotationEffect(.degrees(showAgreement ? 180 : 0))

                                    
                        })
                        .padding(.trailing, 20 * DynamicSizeFactor.factor())
                    }
                    .padding(.vertical, 1)
                }
                        
                if showAgreement {
                    agreementSection()
                        .transition(.opacity.animation(.easeOut))
                }
                        
                Spacer().frame(height: 26 * DynamicSizeFactor.factor())
            }
            CustomBottomButton(action: {
                continueButtonAction()
            }, label: "문의하기", isFormValid: $viewModel.isFormValid)
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(Text("문의하기"))
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

    private func continueButtonAction() {
        if viewModel.isFormValid {
            viewModel.sendInquiryMailApi()
        }
    }
    
    /// Error message
    private func errorMessage(_ message: String) -> some View {
        ZStack(alignment: .leading) {
            Text(message)
                .padding(.leading, 20)
                .font(.B1MediumFont())
                .platformTextColor(color: Color("Red03"))
                .multilineTextAlignment(.leading)
        }
    }
    
    private func agreementSection() -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .platformTextColor(color: .clear)
                .frame(width: 280 * DynamicSizeFactor.factor(), height: 121 * DynamicSizeFactor.factor())
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .inset(by: 0.5)
                        .stroke(Color("Gray01"), lineWidth: 1)
                )
            
            Text("Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")
                .font(.B1MediumFont())
                .minimumScaleFactor(0.001)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .platformTextColor(color: Color("Gray04"))
                .padding(.horizontal, 12 * DynamicSizeFactor.factor())
                .padding(.vertical, 13 * DynamicSizeFactor.factor())
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    InquiryView()
}
