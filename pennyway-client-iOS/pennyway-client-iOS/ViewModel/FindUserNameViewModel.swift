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
                if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
                    print("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    print("Failed to verify: \(error)")
                }
            }
        }
        completion()
    }

//    private func FindUserNameApiResult(result: Result<Data?, Error>, completion: @escaping () -> Void) {
//        switch result {
//        case let .success(data):
//            if let responseData = data {
//                do {
//                    let response = try JSONDecoder().decode(FindUserNameResponseDto.self, from: responseData)
    ////                    showErrorVerificationCode = false
//                    let username = response.data.user.username
//
//                    print(response)
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        case let .failure(error):
//            if let errorWithDomainErrorAndMessage = error as? ErrorWithDomainErrorAndMessage {
//                print("Failed to verify: \(errorWithDomainErrorAndMessage)")
//                if errorWithDomainErrorAndMessage.code == "4000" {
    ////                    showErrorExistingUser = true
//                    print("Failed to verify: \(error)")
//                } else {
    ////                    showErrorVerificationCode = true
//                }
//            } else {
//                print("Failed to verify: \(error)")
//            }
//        }
//        completion()
//    }
}
