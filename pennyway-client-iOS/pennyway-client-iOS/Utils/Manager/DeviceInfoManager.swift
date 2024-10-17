//
//  DeviceInfoManager.swift
//  pennyway-client-iOS
//
//  Created by 최희진 on 10/18/24.
//

import SwiftUI

class DeviceInfoManager {
    
    /// 기기 모델 이름 가져오기
    static func getDeviceModelName() -> String {
        // [1]. 시뮬레이터 체크 수행
        var modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
        if !modelName.isEmpty {
            Log.debug("[DeviceInfoHandler >> getDeviceModelName() :: 디바이스 시뮬레이터]")
            Log.debug("[deviceModelName :: \(modelName)]")
            
            return modelName
        }
        
        // [2]. 실제 디바이스 체크 수행
        let device = UIDevice.current
        let selName = "_\("deviceInfo")ForKey:"
        let selector = NSSelectorFromString(selName)
        
        if device.responds(to: selector) {
            if let result = device.perform(selector, with: "marketing-name")?.takeUnretainedValue() as? NSString {
                modelName = result as String
            }
        }
        
        Log.debug("[DeviceInfoHandler >> getDeviceModelName() :: 실제 디바이스 기기]")
        Log.debug("[deviceModelName :: \(modelName)]")
        
        return modelName
    }
    
    /// 기기 ID 가져오기
    static func getDeviceId() -> String {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            return "Unknown Device ID"
        }
        
        Log.debug("[DeviceInfoHandler >> getDeviceID() :: 기기 ID 확인]")
        Log.debug("[deviceId :: \(deviceId)]")
        
        return deviceId
    }
}
