//
//  PresignedUrlProtocol.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation
import UIKit

protocol PresignedUrlProtocol {
    func generatePresignedUrl(model: PresignedUrlTypeModel, completion: @escaping (Result<PresignedUrlModel, Error>) -> Void)
    func storePresignedUrl(payload: String, image: UIImage, presignedUrl: String, completion: @escaping (Result<Void, Error>) -> Void)
}
