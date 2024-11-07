//
//  ImageLoader.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 11/7/24.
//

import UIKit

class ImageLoader {
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            Log.debug("Invalid URL")
            completion(nil)
            return
        }

        // 이미지 다운로드 작업
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(downloadedImage)
                }
            } else {
                Log.fault("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
