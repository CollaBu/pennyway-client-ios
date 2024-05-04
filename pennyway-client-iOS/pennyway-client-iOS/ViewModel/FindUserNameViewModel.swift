import SwiftUI

class FindUserNameViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var code: String = ""
    @Published var username: String?

    func findUserNameApi(completion: @escaping () -> Void) {
        let findUserNameDto = FindUserNameRequestDto(phone: phone, code: code)
        AuthAlamofire.shared.findUserName(findUserNameDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(FindUserNameResponseDto.self, from: responseData)
                        self.username = response.data.user.username
                        print(response)
                    } catch {
                        print("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
        completion()
    }
}
