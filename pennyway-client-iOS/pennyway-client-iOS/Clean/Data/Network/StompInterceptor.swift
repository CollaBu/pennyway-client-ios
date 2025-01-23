//
//  StompInterceptor.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/23/25.
//

import Foundation

protocol StompInterceptor {
    
    func handle() -> Void
}
