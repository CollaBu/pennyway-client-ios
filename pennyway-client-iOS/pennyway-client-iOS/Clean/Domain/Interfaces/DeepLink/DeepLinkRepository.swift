//
//  DeepLinkRepository.swift
//  pennyway-client-iOS
//
//  Created by 신얀 on 1/20/25.
//

import Foundation

protocol DeepLinkRepository {
    /// URL에서 딥링크를 파싱하는 함수
    func parse(url: URL) -> DeepLink?
}
