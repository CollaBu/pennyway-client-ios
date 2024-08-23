import SwiftUI
import UIKit

// MARK: - CustomInputView

struct CustomInputView: View {
    @Binding var inputText: String // 텍스트 필드에 입력된 내용을 바인딩
    @State var titleText: String? // 타이틀 텍스트 (옵션)
    @State var placeholder: String? // 플레이스홀더 텍스트 (옵션)
    var onCommit: (() -> Void)? // 입력 완료 시 실행할 함수 (옵션)
    var isSecureText: Bool // 텍스트 필드가 비밀번호 필드인지 여부
    var isCustom: Bool? // 커스텀 텍스트 여부 (옵션)
    var showDeleteButton: Bool = false // 삭제 버튼 표시 여부 (기본값: false)
    var deleteAction: (() -> Void)? // 삭제 버튼 클릭 시 실행할 함수 (옵션)
    var keyboardType: UIKeyboardType = .default // 키보드 타입 (기본값: .default)

    let baseAttribute: BaseAttribute = BaseAttribute(font: .B1MediumFont(), color: Color("Gray07"))
    let stringAttribute: StringAttribute = StringAttribute(text: "*", font: .B1MediumFont(), color: Color("Mint03"))

    @State private var isDeleteButtonVisible: Bool = false // 삭제 버튼의 가시성 관리

    var body: some View {
        VStack(alignment: .leading, spacing: 13 * DynamicSizeFactor.factor()) {
            if titleText != nil {
                if isCustom ?? false {
                    titleText?.toAttributesText(base: baseAttribute, stringAttribute)
                        .padding(.horizontal, 20)
                        .font(.B1RegularFont())
                        .platformTextColor(color: Color("Gray04"))
                } else {
                    Text(titleText!)
                        .padding(.horizontal, 20)
                        .font(.B1RegularFont())
                        .platformTextColor(color: Color("Gray04"))
                }
            }

            HStack(spacing: 11 * DynamicSizeFactor.factor()) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46 * DynamicSizeFactor.factor())
                    if inputText.isEmpty {
                        Text(placeholder ?? "")
                            .platformTextColor(color: Color("Gray03"))
                            .padding(.leading, 13 * DynamicSizeFactor.factor())
                            .font(.H4MediumFont())
                    }
                    CustomTextFieldModifier(
                        text: $inputText,
                        isSecureText: isSecureText,
                        onCommit: {
                            onCommit?()
                            isDeleteButtonVisible.toggle()
                        },
                        keyboardType: keyboardType // CustomInputView의 keyboardType 전달
                    )
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
                    .padding(.leading, 12 * DynamicSizeFactor.factor())
                    .padding(.trailing, 35 * DynamicSizeFactor.factor())
                    .frame(height: 46 * DynamicSizeFactor.factor())
                    .font(.H4MediumFont())
                    .onChange(of: inputText) { newValue in
                        isDeleteButtonVisible = !newValue.isEmpty
                    }

                    if showDeleteButton {
                        handleDeleteButtonUtil(isVisible: !inputText.isEmpty && isDeleteButtonVisible, action: {
                            inputText = ""
                            isDeleteButtonVisible = false
                            deleteAction?()

                            AnalyticsManager.shared.trackEvent(AuthEvents.cancelBtnTapped, additionalParams: [AnalyticsConstants.Parameter.btnName: titleText ?? "미설정"])
                        })
                        .offset(x: 120 * DynamicSizeFactor.factor())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - CustomTextFieldModifier

// CustomTextFieldModifier: UIViewRepresentable을 사용하여 SwiftUI에서 UITextField 사용
// 텍스트 입력, 입력 완료, 키보드 타입 등을 제어

struct CustomTextFieldModifier: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextFieldModifier

        init(parent: CustomTextFieldModifier) {
            self.parent = parent
        }

        /// 텍스트 필드 편집 종료 시 호출되는 메서드(빈 화면 터치시 작동)
        func textFieldDidEndEditing(_: UITextField) {
            if !parent.text.isEmpty {
                parent.onCommit?()
            }
        }

        /// 텍스트 필드의 선택이 변경될 때 호출되는 메서드 (입력 시 호출)
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        /// Return 버튼을 눌렀을 때 호출되는 메서드
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onCommit?()
            textField.resignFirstResponder() // 포커스를 해제하여 키보드를 닫음

            return true
        }
    }

    @Binding var text: String // 텍스트 필드의 텍스트 바인딩
    var isSecureText: Bool // 비밀번호 입력 필드인지 여부
    var onCommit: (() -> Void)? // 입력 완료 시 실행할 함수 (옵션)
    var keyboardType: UIKeyboardType // 키보드 타입을 받아서 사용

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = isSecureText // 비밀번호 입력 여부 설정
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .none // 자동 대문자 비활성화
        textField.autocorrectionType = .no // 자동 수정 비활성화
        textField.borderStyle = .none
        textField.keyboardType = keyboardType // 전달받은 키보드 타입 설정
        return textField
    }

    func updateUIView(_ uiView: UITextField, context _: Context) {
        uiView.text = text
    }
}
