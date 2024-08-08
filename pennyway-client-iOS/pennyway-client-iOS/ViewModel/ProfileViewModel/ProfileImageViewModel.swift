

import SwiftUI

class ProfileImageViewModel: ObservableObject {

    func uploadProfileImageApi(_ payload: String) {
        let profileImageUrl = extractPathComponent(from: payload) ?? ""

        Log.debug("?? :\(profileImageUrl)")
        let uploadProfileImageRequestDto = UploadProfileImageRequestDto(profileImageUrl: profileImageUrl)

        UserAccountAlamofire.shared.uploadProfileImage(dto: uploadProfileImageRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(UploadProfileImageResponseDto.self, from: responseData)
                        Log.debug("사용자 프로필 사진 등록 성공: \(response)")          
                        updateUserField(fieldName: profileImageUrl, value: response.data.profileImageUrl)

                    } catch {
                        Log.fault("Error parsing response JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }

    func extractPathComponent(from urlString: String) -> String? {
        // URL 객체 생성
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }

        // URL의 경로 추출
        let fullPath = url.path

        // 경로에서 호스트 부분 제거
        // 예시에서는 "/s3.dev.pennyway.co.kr"를 제거
        let pathComponents = fullPath.split(separator: "/")
        guard pathComponents.count > 1 else {
            return nil
        }

        // 첫 번째 컴포넌트 (빈 문자열)와 호스트 부분을 제외한 나머지 경로 컴포넌트 결합
        let trimmedPath = pathComponents.dropFirst(1).joined(separator: "/")

        return trimmedPath
    }
}
