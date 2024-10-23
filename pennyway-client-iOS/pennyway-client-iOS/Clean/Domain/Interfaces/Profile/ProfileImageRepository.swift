//
//  ProfileImageRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/25/24.
//

import Foundation
import UIKit

protocol ProfileImageRepository {
    /// 사용자 프로필을 삭제하는 함수
    /// - Returns: 사용자 기본 정보 presignedUrl에 빈값을 넣어주기 위해 `String` 타입을 반환
    func deleteUserProfile(completion: @escaping (Result<Void, Error>) -> Void) -> Void

    /// 업데이트된 사용자 프로필 이미지를 서버에 전달하는 함수
    /// - Parameter completion: 이미지 업로드의 성공 또는 실패 여부를 나타내는 Bool 값을 전달하는 클로저
    /// - Returns: 업로드된 이미지의 URL을 반환
    func uploadProfileImage(payload: String, completion: @escaping (Result<String, Error>) -> Void)

    /// 변경된 프로필 이미지 url을 가져오는 함수
    /// - Parameter completion: 이미지 업로드의 성공 또는 실패 여부를 나타내는 Bool 값을 전달하는 클로저
    /// - Returns: 업로드된 이미지의 URL을 반환
    func loadProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
