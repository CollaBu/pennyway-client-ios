<<<<<<< HEAD
=======
//
//  SignUpForm.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 3/26/24.
//

>>>>>>> 7508c42c783da61113f2cb8320cd89aad05ce5a6
import SwiftUI
import Combine

class SignUpFormViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var confirmPw: String = ""
    @Published var showErrorName = false
    @Published var showErrorID = false
    @Published var showErrorPassword = false
    @Published var showErrorConfirmPw = false

    func validateName() {
        let nameRegex = "^[가-힣a-zA-Z]+$"
        showErrorName = !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
        print(showErrorName)
    }

    func validateID() {
        let idRegex = "^[a-z0-9._-]{5,20}$"
        showErrorID = !NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }

    func validatePassword() {
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?~]).{8,16}$"
        showErrorPassword = !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func validateConfirmPw() {
        showErrorConfirmPw = password != confirmPw
    }
}
