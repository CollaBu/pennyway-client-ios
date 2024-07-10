
import Foundation

enum DateFormatterUtil {
    /// 지출 리스트에서 스크롤된 날짜를 감지하기 위해 date를 반환하는 함수
    static func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

    /// 받아온 날짜가 string이기 때문에 날짜 문자열을 Date객체로 변환
    static func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)
    }
}
