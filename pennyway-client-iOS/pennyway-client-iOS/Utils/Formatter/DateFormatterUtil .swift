
import Foundation

enum DateFormatterUtil {
    /// 지출 리스트에서 스크롤된 날짜를 감지하기 위해 date를 반환하는 함수
    static func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    static func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    /// 받아온 날짜가 string이기 때문에 날짜 문자열을 Date객체로 변환
    static func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }

    static func dateFormatString(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMMM d일"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }

    static func getYear(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else {
            return ""
        }
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: date)
    }

    static func formatRelativeDate(from dateString: String) -> String {
        guard let date = dateFromString(dateString) else {
            return dateString
        }

        // 현재 시간
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: date, to: now)

        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)달 전"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week)주일 전"
        } else if let day = components.day, day > 0 {
            switch day {
            case 1: return "어제"
            case 2 ... 6: return "\(day)일 전"
            default: return "1주일 전"
            }
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "오늘"
        }
    }

    static func formatUnReadChatDate(from createdAt: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current

        guard let date = formatter.date(from: createdAt) else {
            return createdAt // 변환 실패 시 원본 반환
        }

        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            let components = calendar.dateComponents([.hour, .minute], from: date, to: now)
            if let minutes = components.minute, minutes == 0 {
                return "지금"
            } else if let minutes = components.minute, minutes < 60 {
                return "\(minutes)분 전"
            } else if let hours = components.hour, hours < 24 {
                return "\(hours)시간 전"
            }
        }

        if calendar.isDateInYesterday(date) {
            return "어제"
        }

        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }

    /// 2024년 4월 11일 형식으로 반환
    static func formatNormalDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // 변환 실패 시 원본 반환
        }
    }
}
