//
//  ChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

protocol ChatStompRepository {
    func getChatServer(completion: @escaping (Result<String, Error>) -> Void)
}
