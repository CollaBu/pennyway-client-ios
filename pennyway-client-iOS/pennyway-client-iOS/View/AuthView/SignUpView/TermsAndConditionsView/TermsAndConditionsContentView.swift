import SwiftUI

struct TermsAndConditionsContentView: View {
    // MARK: Private

    @Binding var isSelectedAllBtn: Bool
    @State private var isSelectedUseBtn: Bool = false
    @State private var isSelectedInfoBtn: Bool = false

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                HStack {
                    Text("이용 약관 동의")
                        .font(.H1SemiboldFont())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 20)

                Spacer().frame(height: 49 * DynamicSizeFactor.factor())

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Button(action: {
                            let newSelection = !isSelectedAllBtn
                            isSelectedAllBtn = newSelection
                            isSelectedUseBtn = newSelection
                            isSelectedInfoBtn = newSelection
                        }, label: {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 44 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: isSelectedAllBtn ? Color("Gray05") : Color("Gray02"))
                                    .cornerRadius(4)

                                Image("icon_check")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White01") : Color("Gray04"))
                                    .padding(.horizontal, 10)
                                Text("모두 동의할게요")
                                    .font(.H4MediumFont())
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White01") : Color("Gray04"))
                                    .padding(.horizontal, 36)
                            }
                        })

                        Spacer().frame(height: 29 * DynamicSizeFactor.factor())

                        VStack(alignment: .leading) {
                            // 하단 text내용 수정필요
                            AgreementSectionView(isSelected: $isSelectedUseBtn, title: "이용약관 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")

                            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                            // 하단 text내용 수정필요
                            AgreementSectionView(isSelected: $isSelectedInfoBtn, title: "개인정보 처리방침 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")
                        }

                        Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                    }
                }
                .padding(.horizontal, 20)
                .onChange(of: isSelectedUseBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
                .onChange(of: isSelectedInfoBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TermsAndConditionsView(viewModel: SignUpNavigationViewModel())
}
