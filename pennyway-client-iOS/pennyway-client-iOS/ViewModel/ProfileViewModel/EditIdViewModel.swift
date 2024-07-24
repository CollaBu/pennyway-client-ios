

import SwiftUI

class EditIdViewModel: ObservableObject {
    @Published var inputId = ""
    @Published var showErrorId = false
    @Published var isDuplicateId = false
    @Published var isFormValid = false

    func validateId() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorId = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: inputId)
        checkDuplicateUserNameApi{ success in
            if success {
                self.validateForm()
            }
        }
    }

    func validateForm() {
        if !showErrorId && !inputId.isEmpty {
            isFormValid = true
        } else {
            isFormValid = false
        }
    }
    
    //아이디 중복 확인
    func checkDuplicateUserNameApi(completion: @escaping (Bool) -> Void) {
        let checkDuplicateRequestDto = CheckDuplicateRequestDto(username: inputId)
        AuthAlamofire.shared.checkDuplicateUserName(checkDuplicateRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(CheckDuplicateResponseDto.self, from: responseData)
                            
                        if response.data.isDuplicate {
                            self.isDuplicateId = true
                            completion(true)
                        } else {
                            self.isDuplicateId = false
                            completion(false)
                        }
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
    }
}
