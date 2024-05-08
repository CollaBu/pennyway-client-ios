import SwiftUI

class ResetPwViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var code: String = ""
    @Published var newPassword: String = ""

    func RequestResetPwApi(completion: @escaping () -> Void) {
        let resetPwDto = RequestResetPwDto(phone: phone, code: code, newPassword: newPassword)
        AuthAlamofire.shared.requestResetPw(resetPwDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ResponseResetPwDto.self, from: responseData)
                        Log.debug(response)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    Log.error("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
            }
        }
        completion()
    }
}
