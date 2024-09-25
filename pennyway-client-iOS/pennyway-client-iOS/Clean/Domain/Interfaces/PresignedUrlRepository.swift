//
//  PresignedUrlProtocol.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

protocol PresignedUrlRepository {
    func generatePresignedUrl(model: PresignedUrlType, completion: @escaping (Result<PresignedUrl, Error>) -> Void)
    func uploadPresignedUrl(payload: String, image: UIImage, presignedUrl: String, completion: @escaping (Result<Void, Error>) -> Void)
}
