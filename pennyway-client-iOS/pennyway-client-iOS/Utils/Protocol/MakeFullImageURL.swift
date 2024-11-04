//
//  MakeFullImageURL.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/4/24.
//

import Foundation

// MARK: - MakeFullImageURL

protocol MakeFullImageURL {
    static func createFullURL(with cdnUrl: String, pathComponent: String) -> String
}

/// 기본 URL과 pathComponent를 결합하는 함수
extension MakeFullImageURL {
    static func createFullURL(with cdnUrl: String, pathComponent: String) -> String {
        guard let url = URL(string: cdnUrl)?.appendingPathComponent(pathComponent) else {
            return cdnUrl // 기본 URL 반환 (잘못된 경우)
        }
        return url.absoluteString
    }
}
