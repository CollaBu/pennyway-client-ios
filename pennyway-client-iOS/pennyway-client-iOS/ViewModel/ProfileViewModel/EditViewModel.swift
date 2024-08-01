

import SwiftUI

class EditViewModel: ObservableObject {
    @Published var username = ""
    @Published var inputId = ""
    @Published var showErrorName = false
    @Published var showErrorId = false
    @Published var isDuplicateId = false
    @Published var isFormValid = false

    func validateId() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorId = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: inputId)
        checkDuplicateUserNameApi { _ in
            self.validateForm()
        }
    }

    func validateName() {
        let nameRegex = "^[가-힣a-zA-Z]{2,8}$"
        showErrorName = !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: username)
    }

    func validateForm() {
        if !isDuplicateId && !inputId.isEmpty {
            if !showErrorId {
                isFormValid = true
            } else if !showErrorName {
                isFormValid = true
            } else {
                isFormValid = false
            }
        }
    }

    /// 아이디 중복 확인
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
                            completion(false)
                        } else {
                            self.isDuplicateId = false
                            completion(true)
                        }
                        Log.debug(response)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let errorWithDomainErrorAndMessage = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(errorWithDomainErrorAndMessage)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
            }
        }
    }

    /// 아이디 수정
    func editUserIdApi(completion: @escaping (Bool) -> Void) {
        let editUserIdDto = CheckDuplicateRequestDto(username: inputId)

        UserAccountAlamofire.shared.editUserId(dto: editUserIdDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)

                        Log.debug("아이디 수정 완료")
                        updateUserField(fieldName: "username", value: self.inputId)

                        completion(true)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(StatusSpecificError)")

                    if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                        self.isDuplicateId = true
                        self.validateForm()
                    }

                } else {
                    Log.error("Failed to verify: \(error)")
                }
                Log.debug("아이디 수정 실패")
                completion(false)
            }
        }
    }

    /// 이름 수정
    func editUsernameApi(completion: @escaping (Bool) -> Void) {
        let editUsernameDto = CheckDuplicateRequestDto(username: inputId)

        UserAccountAlamofire.shared.editUserId(dto: editUsernameDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)

                        Log.debug("이름 수정 완료")
                        updateUserField(fieldName: "username", value: self.inputId)

                        completion(true)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(StatusSpecificError)")

                    if StatusSpecificError.domainError == .conflict && StatusSpecificError.code == ConflictErrorCode.resourceAlreadyExists.rawValue {
                        self.isDuplicateId = true
                        self.validateForm()
                    }

                } else {
                    Log.error("Failed to verify: \(error)")
                }
                Log.debug("아이디 수정 실패")
                completion(false)
            }
        }
    }
}
