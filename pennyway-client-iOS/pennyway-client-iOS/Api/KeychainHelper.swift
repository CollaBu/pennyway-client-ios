import Foundation
import Security

class KeychainHelper {
    static func saveAccessToken(accessToken: String) {
        let keychainQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecValueData: accessToken.data(using: .utf8)!,
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status == errSecDuplicateItem {
            SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData: accessToken.data(using: .utf8)!] as CFDictionary)
        } else if status != noErr {
            print("Failed to save AccessToken to Keychain")
        }
    }
    
    static func loadAccessToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == noErr, let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
    
    static func saveIdToken(oauthUserData: OAuthUserData) {
        do {
            let encoder = JSONEncoder()
            let oauthUserDataEncoded = try encoder.encode(oauthUserData)
            
            let keychainQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: "oauthUserData",
                kSecValueData: oauthUserDataEncoded,
            ]
            
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            if status == errSecDuplicateItem {
                SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData: oauthUserDataEncoded] as CFDictionary)
            } else if status != noErr {
                print("Failed to save UserData to Keychain")
            }
        } catch {
            print("Error encoding UserData: \(error.localizedDescription)")
        }
    }
    
    static func loadIdToken() -> OAuthUserData? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "oauthUserData",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == noErr, let data = item as? Data {
            do {
                let decoder = JSONDecoder()
                let oauthUserData = try decoder.decode(OAuthUserData.self, from: data)
                return oauthUserData
            } catch {
                print("Error decoding UserData: \(error.localizedDescription)")
                return nil
            }
        } else {
            return nil
        }
    }
}
