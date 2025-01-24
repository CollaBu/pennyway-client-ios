//
//  ImageLoadable.swift
//  pennyway-client-iOS
//
//  Created by 아우신얀 on 11/6/24.
//

import SwiftUI

// MARK: - ImageLoadable

protocol ImageLoadable {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

extension ImageLoadable {
    /// 이미지 URL에서 데이터를 다운로드하고 UIImage로 변환하는 함수
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            Log.debug("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(downloadedImage)
                }
            } else {
                Log.fault("Failed to load image for chat room: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}
