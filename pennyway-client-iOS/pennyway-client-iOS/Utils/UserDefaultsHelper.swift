
import Foundation
import os.log

func saveUserData(userData: UserData) {
    do {
        let userDataJSON = try JSONEncoder().encode(userData)

        UserDefaults.standard.set(userDataJSON, forKey: "userData")
        if let jsonString = String(data: userDataJSON, encoding: .utf8) {
            os_log("UserDefaults data: %@", log: .default, type: .debug, jsonString)
        }
    } catch {
        os_log("Error encoding UserData: %@", log: .default, type: .fault, error.localizedDescription)
    }
}

func getUserData() -> UserData? {
    if let userDataJSON = UserDefaults.standard.data(forKey: "userData") {
        do {
            let userData = try JSONDecoder().decode(UserData.self, from: userDataJSON)
            return userData
        } catch {
            os_log("Error decoding UserData: %@", log: .default, type: .fault, error.localizedDescription)
        }
    }
    return nil
}
