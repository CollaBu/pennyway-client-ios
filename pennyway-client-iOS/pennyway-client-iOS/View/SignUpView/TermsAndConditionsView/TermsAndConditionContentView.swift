import SwiftUI

struct TermsAndConditionsContentView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView { // 스크롤 뷰 위치 수정
                HStack {
                    Text("이용 약관 동의")
                        .font(.pretendard(.semibold, size: 24))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 20)

                Spacer().frame(height: 49)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 28) {
                        Button(action: {
                            let newSelection = !isSelectedAllBtn
                            isSelectedAllBtn = newSelection
                            isSelectedUseBtn = newSelection
                            isSelectedInfoBtn = newSelection
                        }, label: {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .platformTextColor(color: isSelectedAllBtn ? Color("Gray05") : Color("Gray02"))
                                    .cornerRadius(4)

                                Image("icon_check")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White") : Color("Gray04"))
                                    .padding(.horizontal, 10)
                                Text("모두 동의할게요")
                                    .font(.pretendard(.medium, size: 14))
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White") : Color("Gray04"))
                                    .padding(.horizontal, 36)
                            }
                        })

                        VStack(alignment: .leading, spacing: 7) {
                            // 수정
                            AgreementSectionView(isSelected: $isSelectedUseBtn, title: "이용약관 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")

                            // 수정
                            AgreementSectionView(isSelected: $isSelectedInfoBtn, title: "개인정보 처리방침 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .onChange(of: isSelectedUseBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
                .onChange(of: isSelectedInfoBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Private

    @State private var isSelectedAllBtn: Bool = false
    @State private var isSelectedUseBtn: Bool = false
    @State private var isSelectedInfoBtn: Bool = false
}

#Preview {
    TermsAndConditionsView(viewModel: SignUpNavigationViewModel())
}
