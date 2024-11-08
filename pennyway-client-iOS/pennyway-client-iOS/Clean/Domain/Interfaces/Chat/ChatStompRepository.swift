//
//  ChatStompRepository.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/15/24.
//

import Foundation

protocol ChatStompRepository {
    func connect(completion: @escaping (Result<Void, Error>) -> Void)
    func disconnect()
    func sendMessage(message: String, destination: Int64, contentType: String, completion: @escaping (Result<Void, Error>) -> Void)
}
