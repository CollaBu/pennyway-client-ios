import Foundation
import Security

class KeychainHelper {
    // MARK: accessToken Keychain

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
            Log.error("Failed to save AccessToken to Keychain")
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
    
    static func deleteAccessToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != noErr {
            Log.error("Failed to delete AccessToken from Keychain")
        }
    }
    
    // MARK: OAuthUserData Keychain
    
    static func saveOAuthUserData(oauthUserData: OAuthUserData) {
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
                Log.error("Failed to save oauthUserData to Keychain")
            }
        } catch {
            Log.fault("Error encoding oauthUserData: \(error.localizedDescription)")
        }
    }
    
    static func loadOAuthUserData() -> OAuthUserData? {
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
                Log.fault("Error decoding oauthUserData: \(error.localizedDescription)")
                return nil
            }
        } else {
            return nil
        }
    }

    static func deleteOAuthUserData() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "oauthUserData"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != noErr {
            Log.error("Failed to delete oauthUserData from Keychain")
        }
    }
}
