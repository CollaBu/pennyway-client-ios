//
//  GeneratePresignedUrlModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation

struct PresignedUrlModel {
    let presignedUrl: String
}

struct PresignedUrlTypeModel {
    let type: String
    let ext: String
}

extension PresignedUrlTypeModel {
    func toDto() -> GeneratePresigendUrlRequestDto {
        return GeneratePresigendUrlRequestDto(
            type: self.type,
            ext: self.ext
        )
    }
}
