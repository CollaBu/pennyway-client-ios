
import Combine
import SwiftUI

struct InquiryView: View {
    @StateObject var viewModel = InquiryViewModel()
    @State private var isSelectedCategory: Bool = false
    @State private var isSelectedAgreeBtn: Bool = false
    @State private var showAgreement: Bool = false
    @State private var isDeleteButtonVisible: Bool = false

    @Environment(\.presentationMode) var presentationMode

    let placeholder: String = "문의 내용을 입력해주세요"
    
    var body: some View {
        ZStack {
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
                        isDeleteButtonVisible = false
                        
                    }, isSecureText: false, showDeleteButton: true, deleteAction: {
                        viewModel.email = ""
                        viewModel.validateForm()
                        isDeleteButtonVisible = false
                    })
                    
                    ZStack(alignment: .leading) {
                        if viewModel.showErrorEmail {
                            Spacer().frame(height: 9 * DynamicSizeFactor.factor())
                            
                            ErrorText(message: "유효하지 않는 이메일 형식이에요", color: Color("Red03"))
                        }
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
                            .buttonStyle(BasicButtonStyleUtil())
                            
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
                            .buttonStyle(BasicButtonStyleUtil())
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
            .navigationBarColor(UIColor(named: "White01"), title: "문의하기")
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

    private func continueButtonAction() {
        if viewModel.isFormValid {
            viewModel.dismissAction = {
                self.presentationMode.wrappedValue.dismiss()
            }
            // 디바운스 타이머 트리거
            viewModel.debounceTimer.send(())
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
            VStack {
                Text("답변을 보내드리기 위해 필요해요.")
                    .font(.B1MediumFont())
                    .minimumScaleFactor(0.001)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .platformTextColor(color: Color("Gray04"))
                    .padding(.horizontal, 12 * DynamicSizeFactor.factor())
                    .padding(.vertical, 13 * DynamicSizeFactor.factor())
                Spacer()
                
                Link("[자세히 보기]", destination: URL(string: "https://polar-cheek-a39.notion.site/419c51f95b8146d89a9ec06fbdfa4b0a")!)
                    .font(.B1MediumFont())
                    .minimumScaleFactor(0.001)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .platformTextColor(color: Color("Gray04"))
                    .padding(.horizontal, 12 * DynamicSizeFactor.factor())
                    .padding(.vertical, 13 * DynamicSizeFactor.factor())
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    InquiryView()
}
