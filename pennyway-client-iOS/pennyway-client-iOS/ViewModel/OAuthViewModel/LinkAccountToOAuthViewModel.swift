import Foundation

class LinkAccountToOAuthViewModel: ObservableObject {
    func linkAccountToOAuthApi(completion: @escaping (Bool) -> Void) { // 바로 로그인 처리
        let linkAccountToOAuthDto = LinkAccountToOAuthRequestDto(password: RegistrationManager.shared.password, phone: RegistrationManager.shared.formattedPhoneNumber ?? "", code: RegistrationManager.shared.code)

        AuthAlamofire.shared.linkAccountToOAuth(linkAccountToOAuthDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AuthResponseDto.self, from: responseData)
                        Log.debug(response)
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                completion(false)
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }
}
