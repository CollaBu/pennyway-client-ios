import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let `default` = OSLog(subsystem: subsystem, category: "Default")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let fault = OSLog(subsystem: subsystem, category: "Fault")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

// MARK: - Log

enum Log {
    /// # Level
    /// - default : 일반적인 정보 로그
    /// - debug : 디버깅 로그
    /// - info : 시스템 상태 파악 로그
    /// - fault : 실행 중 발생하는 버그
    /// - error :  심각한 오류
    enum Level {
        case `default`
        case debug
        case info
        case error
        case fault

        fileprivate var category: String {
            switch self {
            case .`default`:
                return "☑️ DEFAULT"
            case .debug:
                return "⌨️ DEBUG"
            case .info:
                return "ℹ️ INFO"
            case .error:
                return "❌ ERROR"
            case .fault:
                return "🚫 FAULT"
            }
        }

        fileprivate var osLogType: OSLogType {
            switch self {
            case .`default`:
                return .default
            case .debug:
                return .debug
            case .info:
                return .info
            case .fault:
                return .fault
            case .error:
                return .error
            }
        }
    }

    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
        let extraMessage: String = arguments.map { String(describing: $0) }.joined(separator: " ")
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message) \(extraMessage)"

        switch level {
        case .`default`:
            logger.notice("\(logMessage, privacy: .public)")
        case .debug:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .fault:
            logger.fault("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        }
    }
}

// MARK: - utils

extension Log {
    /// # default
    /// - Note : 일반적인 정보나 이벤트 기록할 때 사용
    static func `default`(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .default)
    }

    /// # debug
    /// - Note : 개발 중 코드 디버깅 시 사용할 수 있는 유용한 정보
    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }

    /// # info
    /// - Note : 문제 해결시 활용할 수 있는, 도움이 되지만 필수적이지 않은 정보
    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }

    /// # fault
    /// - Note : 실행 중 발생하는 버그나 잘못된 동작
    static func fault(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .fault)
    }

    /// # error
    /// - Note : 심각한 오류나 예외 상황
    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }
}
