import Foundation
import os.log

// MARK: - Log

enum Log {
    /// # Level
    /// - default : 일반적인 정보 로그
    /// - debug : 디버깅 로그
    /// - info : 시스템 상태 파악 로그
    /// - warning: 경고에 대한 정보 기록
    /// - fault : 실행 중 발생하는 버그
    /// - error :  심각한 오류
    enum Level {
        case `default`
        case debug
        case info
        case warning
        case fault
        case error

        fileprivate var category: String {
            switch self {
            case .default:
                return "☑️ DEFAULT"
            case .debug:
                return "⌨️ DEBUG"
            case .info:
                return "ℹ️ INFO"
            case .warning:
                return "⚠️ WARNING"
            case .fault:
                return "🚫 FAULT"
            case .error:
                return "❌ ERROR"
            }
        }
    }

    private static func log(_ message: Any, level: Level) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: level.category)
        let logMessage = "\(level.category): \(message)" // 메시지에 카테고리 포함

        switch level {
        case .default:
            logger.notice("\(logMessage, privacy: .private)")
        case .debug:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .warning:
            logger.warning("\(logMessage, privacy: .private)")
        case .fault:
            logger.fault("\(logMessage, privacy: .private)")
        case .error:
            logger.error("\(logMessage, privacy: .private)")
        }
    }
}

// MARK: - utils

extension Log {
    /// # default
    /// - Note : 일반적인 정보나 이벤트 기록할 때 사용
    static func `default`(_ message: Any) {
        log(message, level: .default)
    }

    /// # debug
    /// - Note : 개발 중 코드 디버깅 시 사용할 수 있는 유용한 정보
    static func debug(_ message: Any) {
        log(message, level: .debug)
    }

    /// # info
    /// - Note : 문제 해결시 활용할 수 있는, 도움이 되지만 필수적이지 않은 정보
    static func info(_ message: Any) {
        log(message, level: .info)
    }

    /// # warning
    /// - Note : 경고에 대한 정보, 잠재적으로 문제가 될 수 있는 상황
    static func warning(_ message: Any) {
        log(message, level: .warning)
    }

    /// # fault
    /// - Note : 실행 중 발생하는 버그나 잘못된 동작
    static func fault(_ message: Any) {
        log(message, level: .fault)
    }

    /// # error
    /// - Note : 심각한 오류나 예외 상황
    static func error(_ message: Any) {
        log(message, level: .error)
    }
}
