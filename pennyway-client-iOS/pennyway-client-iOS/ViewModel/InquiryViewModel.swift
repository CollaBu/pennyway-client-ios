import Combine
import SwiftUI

class InquiryViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var content: String = ""
    @Published var category: String = ""
    @Published var showErrorEmail = false
    @Published var isFormValid: Bool = false
    @Published var isSelectedAgreeBtn = false

    var cancellables = Set<AnyCancellable>()
    let debounceInterval = 0.3
    var debounceTimer = PassthroughSubject<Void, Never>()

    var dismissAction: (() -> Void)?

    init() {
        debounceTimer
            .debounce(for: .seconds(debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.sendInquiryMailApi { success in
                    if success {
                        self?.dismissAction?()
                        Log.debug("디바운싱 문의하기 마지막 이벤트 보냄")
                    } else {
                        Log.debug("문의하기 디바운싱 실패")
                    }
                }
            }
            .store(in: &cancellables)
    }

    let categoryMapping: [String: String] = [
        "이용 관련": "UTILIZATION",
        "오류 신고": "BUG_REPORT",
        "서비스 제안": "SUGGESTION",
        "기타": "ETC",
    ]

    func getCategoryCode(for category: String) -> String {
        return categoryMapping[category] ?? "ETC"
    }

    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        showErrorEmail = !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    func validateForm() {
        if !email.isEmpty && !content.isEmpty && !category.isEmpty && !showErrorEmail && isSelectedAgreeBtn {
            isFormValid = true
        } else {
            isFormValid = false
        }
    }

    func sendInquiryMailApi(completion: @escaping (Bool) -> Void) {
        let categoryCode = getCategoryCode(for: category)

        let inquiryRequestDto = BackofficeRequestDto(email: email, content: content, category: categoryCode)

        BackofficeAlamofire.shared.sendInquiryMail(inquiryRequestDto) { result in
            switch result {
            case let .success(data):
                do {
                    if let responseData = data {
                        let response = try JSONDecoder().decode(SmsResponseDto.self, from: responseData)

                        Log.debug("문의하기 api 응답 성공 : \(response)")
                        completion(true)
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
                completion(false)
            }
        }
    }
}
