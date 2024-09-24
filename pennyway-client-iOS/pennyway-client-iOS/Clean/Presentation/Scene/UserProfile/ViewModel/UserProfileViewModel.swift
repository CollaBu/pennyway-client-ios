
import Foundation
import UIKit

// MARK: - UserProfileViewModelInput

protocol UserProfileViewModelInput {
    func viewDidLoad()
    func updateData(_ newName: String)
    func updateProfileImage(from url: String)
    func deleteProfileImage(completion: @escaping (Bool) -> Void) // 삭제 메서드 추가
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

// MARK: - UserProfileViewModelOutput

protocol UserProfileViewModelOutput {
    var userData: Observable<UserProfileItemModel> { get }
}

// MARK: - UserProfileViewModel

protocol UserProfileViewModel: UserProfileViewModelInput, UserProfileViewModelOutput {}

// MARK: - DefaultUserProfileViewModel

class DefaultUserProfileViewModel: UserProfileViewModel {
    // TODO: 이름 수정하기!
    var userData: Observable<UserProfileItemModel>

    private let fetchUserProfileUseCase: FetchUserProfileUseCase // 유저 정보 조회
    private let deleteUserProfileUseCase: DeleteUserProfileUseCase // 사용자 프로필 삭제
    private let updateUserProfileUseCase: UpdateUserProfileUseCase // 업데이트된 이미지를 서버에 전달
    // presingned url
    // profileIamge
    // deleteProfileImage

    init(fetchUserProfileUseCase: FetchUserProfileUseCase, deleteUserProfileUseCase: DeleteUserProfileUseCase, updateUserProfileUseCase: UpdateUserProfileUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.deleteUserProfileUseCase = deleteUserProfileUseCase
        self.updateUserProfileUseCase = updateUserProfileUseCase

        userData = Observable(UserProfileItemModel(
            username: "",
            name: "기본", 
            profileImageUrl: ""
        ))
    }

    /// usecase를 호출하여 사용자 데이터를 업데이트하는 메서드
    private func updateUserData() {
        userData.value.username = fetchUserProfileUseCase.execute().username
        userData.value.name = fetchUserProfileUseCase.execute().name

        Log.debug(userData.value)
    }

    /// 이름을 업데이트하는 메서드
    private func updateName(_ newName: String) {
        Log.debug("Updated name to \(newName)")
        Log.debug("Updated \(userData.value)")
    }

    /// 업데이트된 사진을 불러오는 함수
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        updateUserProfileUseCase.loadProfileImage(from: url) { [weak self] result in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self?.userData.value.imageUpdate(image: image)
                    completion(.success(image)) // 이미지 로드 성공 시 completion 호출
                }
            case let .failure(error):
                Log.debug("Failed to load image: \(error)")
                completion(.failure(error)) // 이미지 로드 실패 시 completion 호출
            }
        }
    }

    /// 업데이트 된 사진을 서버에 전달하는 함수
    func updateProfileImage(from url: String) {
        updateUserProfileUseCase.update(from: url) { result in
            switch result {
            case let .success(response):
                Log.debug("[UserProfileViewModel]-프로필 이미지 업데이트 성공: \(response)")
                self.loadProfileImage(from: url) { loadResult in
                    switch loadResult {
                    case let .success(image):
                        DispatchQueue.main.async {
                            self.userData.value.imageUpdate(image: image) // 이미지 업데이트
                            Log.debug("[UserProfileViewModel]-이미지 업데이트 성공")
                        }
                    case let .failure(error):
                        Log.debug("[UserProfileViewModel]-이미지 로드 실패: \(error)")
                    }
                }

            case let .failure(error):
                Log.debug("[UserProfileViewModel]-프로필 이미지 업데이트 실패: \(error)")
            }
        }
    }

    /// 프로필 사진 삭제하는 함수
    func deleteProfileImage(completion: @escaping (Bool) -> Void) {
        deleteUserProfileUseCase.delete { result in
            switch result {
            case true:
                self.userData.value.imageDelete()
                completion(true)
                Log.debug("[UserProfileViewModel]-프로필 이미지가 성공적으로 삭제")
            case false:
                completion(false)
                Log.debug("[UserProfileViewModel]-프로필 이미지 삭제 실패")
            }
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultUserProfileViewModel {
    func viewDidLoad() {
        updateUserData()
    }

    func updateData(_ newName: String) {
        updateName(newName)
    }
}
