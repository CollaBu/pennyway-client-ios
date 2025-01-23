//
//  GenerateUuid.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 1/7/25.
//

import Foundation

class GenerateUuid {
    static func generateSequentialUuid() -> UUID {
        var uuidBytes = [UInt8](repeating: 0, count: 16)

        // 현재 시간을 밀리초 단위로 가져오기
        let timestamp = UInt64(Date().timeIntervalSince1970 * 1000)

        // 상위 48비트: 타임스탬프 (6 바이트)
        uuidBytes[0 ... 5] = withUnsafeBytes(of: timestamp.bigEndian) { Array($0) }[2 ... 7]

        // 버전: UUIDv7의 경우 4비트 값 0111
        uuidBytes[6] = (uuidBytes[6] & 0x0F) | 0x70

        // Variant: 상위 2비트는 10
        uuidBytes[8] = (uuidBytes[8] & 0x3F) | 0x80

        // 나머지 6바이트: 랜덤 값
        for i in 9 ..< 16 {
            uuidBytes[i] = UInt8.random(in: 0 ... 255)
        }

        // UUID로 변환
        return UUID(uuid: uuidBytes.withUnsafeBytes { $0.load(as: uuid_t.self) })
    }
}
