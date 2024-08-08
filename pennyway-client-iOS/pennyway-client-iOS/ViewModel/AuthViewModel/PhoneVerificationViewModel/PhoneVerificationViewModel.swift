
import os.log
import SwiftUI

class PhoneVerificationViewModel: ObservableObject {
    // MARK: Private

    private var timer: Timer?
    var formattedPhoneNumber: String {
        return PhoneNumberFormatterUtil.formatPhoneNumber(from: phoneNumber) ?? ""
    }

    // MARK: Internal

    @Published var firstPhoneNumber = ""
    @Published var phoneNumber: String = ""

    @Published var code: String = ""
    @Published var showErrorPhoneNumberFormat = false
    @Published var showErrorVerificationCode = false
    @Published var showErrorExistingUser = false
    @Published var showErrorApiRequest = false
    @Published var isFormValid = false

    @Published var phone: String = ""
    @Published var username: String?
    @Published var isFindUsername = false

    /// Timer
    @Published var isTimerHidden = true
    @Published var timerSeconds = 300
    @Published var isTimerRunning = false
    @Published var isDisabledButton = false

    func requestVerificationCodeAction() {
        if !showErrorPhoneNumberFormat && !isDisabledButton {
            isDisabledButton = true
            isTimerHidden = false
        }
    }

    func validatePhoneNumber() {
        if phoneNumber.prefix(3) != "010" && phoneNumber.prefix(3) != "011" && phoneNumber.count == 11 {
            showErrorPhoneNumberFormat = true
        } else {
            showErrorPhoneNumberFormat = false
        }
    }

    func validateForm() {
        isFormValid = (!phoneNumber.isEmpty && !code.isEmpty && timerSeconds > 0)
    }

    // MARK: 인증번호 코드 요청 API

    func requestVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let verificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(verificationCodeDto, type: VerificationType.general) { result in
                self.handleVerificationCodeApiResult(result: result, type: VerificationType.general, completion: completion)
            }
        }
    }

    // MARK: OAuth 인증번호 코드 요청 API

    func requestOAuthVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()

        let oauthVerificationCodeDto = OAuthVerificationCodeRequestDto(phone: formattedPhoneNumber, provider: OAuthRegistrationManager.shared.provider)

        if !showErrorPhoneNumberFormat {
            OAuthAlamofire.shared.oauthReceiveVerificationCode(oauthVerificationCodeDto, type: VerificationType.oauth) { result in
                self.handleVerificationCodeApiResult(result: result, type: VerificationType.oauth, completion: completion)
            }
        }
    }

    // MARK: 아이디 찾기 인증번호 코드 요청 API

    func requestUserNameVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let usernameVerificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(usernameVerificationCodeDto, type: VerificationType.username) { result in
                self.handleVerificationCodeApiResult(result: result, type: VerificationType.username, completion: completion)
            }
        }
    }

    // MARK: 비밀번호 찾기 인증번호 코드 요청 API

    func requestPwVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let passwordVerificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(passwordVerificationCodeDto, type: VerificationType.password) { result in
                self.handleVerificationCodeApiResult(result: result, type: VerificationType.password, completion: completion)
            }
        }
    }

    // MARK: 일반 인증번호 검증 API

    func requestVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = VerificationRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.verifyVerificationCode(verificationDto) { result in
                self.handleVerificationApiResult(result: result, completion: completion)
            }
        }
    }

    // MARK: OAuth 인증번호 검증 API

    func requestOAuthVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let oauthVerificationDto = OAuthVerificationRequestDto(phone: formattedPhoneNumber, code: code, provider: OAuthRegistrationManager.shared.provider)

        if isFormValid {
            OAuthAlamofire.shared.oauthVerifyVerificationCode(oauthVerificationDto) { result in
                self.handleOAuthVerificationApiResult(result: result, completion: completion)
            }
        }
    }

    // MARK: 아이디 찾기 인증번호 검증 API

    func requestUserNameVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = FindUserNameRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.findUserName(verificationDto) { result in
                self.handleFindUserNameApi(result: result, completion: completion)
                switch result {
                case let .success(data):
                    if data != nil {
                        self.handleFindUserNameApi(result: result, completion: completion)
                    }
                case let .failure(error):
                    if let StatusSpecificError = error as? StatusSpecificError {
                        Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                        if StatusSpecificError.domainError == .unauthorized && StatusSpecificError.code == UnauthorizedErrorCode.missingOrInvalidCredentials.rawValue {
                            self.showErrorVerificationCode = true
                        } else if StatusSpecificError.domainError == .notFound && StatusSpecificError.code == NotFoundErrorCode.resourceNotFound.rawValue {
                            self.showErrorExistingUser = true
                        }

                    } else {
                        Log.error("Network request failed: \(error)")
                    }
                }
            }
        }
    }

    // MARK: 비밀번호 찾기 번호 검증 API

    func requestPwVerifyVerificationCodeApi(completion: @escaping () -> Void) {
        let verificationDto = VerificationRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            AuthAlamofire.shared.receivePwVerifyVerificationCode(verificationDto) { result in
                self.receivePwVerifyVerificationCode(result: result, completion: completion)

                switch result {
                case let .success(data):
                    if data != nil {
                        self.receivePwVerifyVerificationCode(result: result, completion: completion)
                    }
                case let .failure(error):
                    if let StatusSpecificError = error as? StatusSpecificError {
                        Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                        if StatusSpecificError.domainError == .unauthorized && StatusSpecificError.code == UnauthorizedErrorCode.missingOrInvalidCredentials.rawValue {
                            self.showErrorVerificationCode = true
                        } else if StatusSpecificError.domainError == .notFound && StatusSpecificError.code == NotFoundErrorCode.resourceNotFound.rawValue {
                            self.showErrorExistingUser = true
                        }

                    } else {
                        Log.error("Network request failed: \(error)")
                    }
                }
                completion()
            }
        }
    }

    // MARK: 전화번호 수정 인증번호 코드 요청 API

    func requestEditVerificationCodeApi(completion: @escaping () -> Void) {
        validatePhoneNumber()
        requestVerificationCodeAction()
        let verificationCodeDto = VerificationCodeRequestDto(phone: formattedPhoneNumber)

        if !showErrorPhoneNumberFormat {
            AuthAlamofire.shared.receiveVerificationCode(verificationCodeDto, type: VerificationType.phone) { result in
                self.handleVerificationCodeApiResult(result: result, type: VerificationType.phone, completion: completion)
            }
        }
    }

    // MARK: 전화번호 수정 API

    func editUserPhoneNumberApi(completion: @escaping () -> Void) {
        let editPhoneNumberDto = VerificationRequestDto(phone: formattedPhoneNumber, code: code)

        if isFormValid {
            UserAccountAlamofire.shared.editUserPhoneNumber(dto: editPhoneNumberDto) { result in
                self.handleEditUserPhoneNumberApi(result: result, completion: completion)
            }
        }
    }

    // MARK: Timer function

    func judgeTimerRunning() {
        if !showErrorPhoneNumberFormat && !isTimerHidden {
            if isTimerRunning {
                stopTimer()
                isTimerHidden = false
                startTimer()
            } else {
                startTimer()
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerSeconds > 0 && self.isTimerRunning {
                self.timerSeconds -= 1
            } else {
                self.stopTimer()
                self.isDisabledButton = false
            }
        }
        isTimerRunning = true
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        isTimerHidden = true
        timerSeconds = 300
    }
}
