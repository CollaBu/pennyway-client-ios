
import Foundation
import SwiftUI

// MARK: - DefaultProfileImageRepository

final class DefaultProfileImageRepository: ProfileImageRepository {
    /// 사진 삭제 api 호출
    func deleteUserProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        UserAccountAlamofire.shared.deleteProfileImage { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ErrorResponseDto.self, from: responseData)

                        updateUserField(fieldName: "profileImageUrl", value: "")
                        Log.debug("사진 삭제 완료")

                        completion(.success(()))
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
                completion(.failure(error))
            }
        }
    }

    /// 사진 등록 api 호출
    func uploadProfileImage(payload: String, completion _: @escaping (Result<String, Error>) -> Void) {
        let profileImageUrl = extractPathComponent(from: payload) ?? ""
        let uploadProfileImageRequestDto = UploadProfileImageRequestDto(profileImageUrl: profileImageUrl)

        UserAccountAlamofire.shared.uploadProfileImage(dto: uploadProfileImageRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(UploadProfileImageResponseDto.self, from: responseData)
                        Log.debug("사용자 프로필 사진 등록 성공: \(response)")
                        updateUserField(fieldName: "profileImageUrl", value: response.data.profileImageUrl)

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
        let pathComponents = fullPath.split(separator: "/")
        guard pathComponents.count > 1 else {
            return nil
        }

        // 첫 번째 컴포넌트 (빈 문자열)와 호스트 부분을 제외한 나머지 경로 컴포넌트 결합
        let trimmedPath = pathComponents.dropFirst(1).joined(separator: "/")

        return trimmedPath
    }

    /// userDefaults의 저장된 이미지 가저옴
    /// Warning: error발생시 강제언래핑해서 에러를 처리하고 있음! - 위험요소
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }

        // URLSession을 사용하여 주어진 URL에서 데이터를 비동기적으로 다운로드
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil, let downloadedImage = UIImage(data: data) {
                // 이미지 URL이 존재하고 이미지를 성공적으로 다운로드한 경우
                DispatchQueue.main.async {
                    completion(.success(downloadedImage))
                }
            } else {
                // 에러가 발생했거나 유효한 데이터를 받지 못한 경우
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
            }
        }.resume()
    }
}
