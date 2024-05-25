import SwiftUI

class InquiryViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var content: String = ""
    @Published var category: String = ""
    @Published var showErrorEmail = false
    @Published var isFormValid: Bool = false

    let categoryMapping: [String: String] = [
        "이용 관련": "UTILIZATION",
        "오류 신고": "BUG_REPORT",
        "서비스 제안": "SUGGESTION",
        "기타": "ETC"
    ]

    func getCategoryCode(for category: String) -> String {
        return categoryMapping[category] ?? "ETC"
    }

    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        showErrorEmail = !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func validateForm() {
        if !email.isEmpty && !content.isEmpty && !category.isEmpty && !showErrorEmail {
            isFormValid = true
        } else {
            isFormValid = false
        }
    }

    func sendInquiryMailApi() {
        let categoryCode = getCategoryCode(for: category)

        let inquiryRequestDto = InquiryRequestDto(email: email, content: content, category: categoryCode)

        InquiryAlamofire.shared.sendInquiryMail(inquiryRequestDto) { result in
            switch result {
            case let .success(data):
                do {
                    if let responseData = data {
                        let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)
                        NavigationUtil.popToRootView()

                        Log.debug("문의하기 api 응답 성공 : \(response)")
                    }
                } catch {
                    Log.fault("Error decoding JSON: \(error)")
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}
