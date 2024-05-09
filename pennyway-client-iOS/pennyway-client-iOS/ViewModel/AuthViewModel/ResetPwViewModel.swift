import SwiftUI

class ResetPwViewModel: ObservableObject {
    @Published var newPassword: String = ""
    @Published var isResetPwSuccessful: Bool = false

    func requestResetPwApi(completion: @escaping (Bool) -> Void) {
        Log.debug("value: \(RegistrationManager.shared.phoneNumber)")

        let resetPwDto = RequestResetPwDto(phone: RegistrationManager.shared.phoneNumber, code: RegistrationManager.shared.code, newPassword: newPassword)
        AuthAlamofire.shared.requestResetPw(resetPwDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    Log.debug("비밀번호 재설정 api 요청 성공")
                    self.isResetPwSuccessful = true
                    completion(true)
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
                completion(false)
            }
        }
    }
}
