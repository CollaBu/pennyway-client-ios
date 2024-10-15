//
//  ChatServerRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

protocol ChatServerRepository {
    func getChatServer(completion: @escaping (Result<Void, Error>) -> Void)
}
