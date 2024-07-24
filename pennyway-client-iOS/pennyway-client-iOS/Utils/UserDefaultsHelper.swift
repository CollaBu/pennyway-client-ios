
import Foundation
import os.log

func saveUserData(userData: UserData) {
    do {
        let userDataJSON = try JSONEncoder().encode(userData)

        UserDefaults.standard.set(userDataJSON, forKey: "userData")
        if let jsonString = String(data: userDataJSON, encoding: .utf8) {
            Log.default("UserDefaults data: \(jsonString)")
            
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

func updateUserField<T>(fieldName: String, value: T) {
    if var userData = getUserData() {
        switch fieldName {
        case "username":
            userData.username = value as! String
        case "name":
            userData.name = value as! String
        case "profileImageUrl":
            userData.profileImageUrl = value as! String
        case "phone":
            userData.phone = value as! String
        case "notifySetting":
            userData.notifySetting = value as! NotifySetting
        case "oauthAccount":
            userData.oauthAccount = value as! OauthAccount
        default:
            Log.default("Invalid field name: \(fieldName)")
            return
        }
        saveUserData(userData: userData)
    } else {
        Log.default("No user data found to update")
    }
}
