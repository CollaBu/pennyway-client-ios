
import Foundation

/// 지출 리스트에서 스크롤된 날짜를 감지하기 위해 date를 반환하는 함수
enum ScrollToDateUtil {
    static func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}
