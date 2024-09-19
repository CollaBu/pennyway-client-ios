//
//  StorePresignedUrlModel.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 9/20/24.
//

import Foundation

struct StorePresignedUrlModel: Equatable {
    let algorithm: String
    let date: String
    let signedHeaders: String
    let credential: String
    let expires: String
    let signature: String
}
