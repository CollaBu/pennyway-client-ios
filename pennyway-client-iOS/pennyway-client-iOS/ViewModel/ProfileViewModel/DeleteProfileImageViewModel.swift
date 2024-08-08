
import SwiftUI

class DeleteProfileImageViewModel: ObservableObject {
    @Published var profileImageUrl: String
    
    /// 프로필 사진 삭제 api
    func deleteProfileImageApi(completion: @escaping (Bool) -> Void) {
        UserAccountAlamofire.shared.deleteProfileImage { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)
                        self.profileImageUrl = "" // 삭제 성공 시 profileImageUrl 초기화
                        updateUserField(fieldName: "profileImageUrl", value: self.profileImageUrl)
                        
                        Log.debug("사진 삭제 완료")
                        completion(true)
                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("Failed to verify: \(StatusSpecificError)")
                } else {
                    Log.error("Failed to verify: \(error)")
                }
                Log.debug("이름 수정 실패")
                completion(false)
            }
        }
    }
}
